# typed: strict
# frozen_string_literal: true

require "did_you_mean"
require "json"
require "tap"
require "uri"
require "utils"
require "utils/github/api"

module Homebrew
  module Cmd
    class Surf < AbstractCommand
      # Taps are named `homebrew-<tap>`: `Homebrew/homebrew-core`, `homebrew-ffmpeg/homebrew-ffmpeg`.
      TAP_PREFIX = "homebrew-"
      REPOSITORY_SEARCH_URL = "https://api.github.com/search/repositories"
      REPOSITORY_SEARCH_QUERY = "#{TAP_PREFIX} in:name fork:false archived:false".freeze
      REPOSITORIES_PER_PAGE = 100
      # The query matches any repository with `homebrew` in its name, not only the prefixed ones,
      # so pages are requested a few at a time, to overlap the requests, until enough taps are
      # found, or until this many pages have been searched.
      REPOSITORY_SEARCH_PAGES = 2
      MAX_REPOSITORY_SEARCH_PAGES = 10
      # `Tree.entries` is not paginated, so every directory needs its own field in the request.
      # They are aliased into a single request, but the more of them, the larger the response, as
      # `Homebrew/homebrew-core` alone has thousands of formulae.
      DIRECTORIES_PER_REQUEST = 25
      # `Homebrew/homebrew-core` and `Homebrew/homebrew-cask` group their files in subdirectories,
      # e.g. `Formula/a/ack.rb`, so `Formula` and `Casks` are listed at two depths.
      MAX_DIRECTORY_DEPTH = 2
      DIRECTORIES = %w[Formula Casks].freeze
      DEFAULT_REPOSITORIES = 100
      MAX_RESULTS = 25

      class Match < T::Struct
        const :name, String
        const :tap_name, String
        const :path, String
        const :rank, T::Array[Integer]

        sig { returns(String) }
        def kind = path.start_with?("Formula/") ? "Formula" : "Cask"

        sig { returns(String) }
        def url = "https://github.com/#{tap_name}/blob/HEAD/#{path}"
      end

      cmd_args do
        description <<~EOS
          Search the formulae and casks of every tap on GitHub for <query>, ignoring case and
          allowing for typos, so `brew surf djviw` still finds `djview`.

          Only repositories named like `homebrew-*` are searched, e.g. `Homebrew/homebrew-core`
          and `homebrew-ffmpeg/homebrew-ffmpeg`, and within them only the `Formula` and `Casks`
          directories. A GitHub API token is required, in `$HOMEBREW_GITHUB_API_TOKEN`.
        EOS
        flag "--repos=",
             description: "Number of taps to search. Defaults to #{DEFAULT_REPOSITORIES}."
        switch "--json",
               description: "Print the matches as JSON."
        named_args :query, number: 1
      end

      sig { override.void }
      def run
        odie "Unset `HOMEBREW_NO_GITHUB_API` to search GitHub." if Homebrew::EnvConfig.no_github_api?
        if ::GitHub::API.credentials_type == :none
          odie "Set `HOMEBREW_GITHUB_API_TOKEN` to a GitHub token to search GitHub."
        end

        query = args.named.first
        taps = tap_repositories
        odie "No repositories named like `#{TAP_PREFIX}*` found." if taps.empty?

        matches = matches(taps, query)

        if args.json?
          puts JSON.pretty_generate(matches: matches.map { |match|
            { name: match.name, kind: match.kind, tap: match.tap_name, path: match.path, url: match.url }
          })
          return
        end

        odie "No formulae or casks found for #{query.inspect} in #{taps.size} taps." if matches.empty?

        print_matches(matches)
      end

      private

      # The most starred repositories named like `homebrew-*`, as `owner/name`.
      sig { returns(T::Array[String]) }
      def tap_repositories
        limit = args.repos.to_i
        limit = DEFAULT_REPOSITORIES if limit <= 0

        taps = []
        (1..MAX_REPOSITORY_SEARCH_PAGES).step(REPOSITORY_SEARCH_PAGES) do |page|
          break if taps.size >= limit

          pages = (page...(page + REPOSITORY_SEARCH_PAGES)).to_a
          repositories = ::Utils.parallel_map(pages) { |number| search_repositories(number) }.flatten
          taps.concat(repositories.filter_map do |repository|
            repository["full_name"] if repository["name"].start_with?(TAP_PREFIX)
          end)
        end

        # The search is ordered by stars, so a new tap with none can be hundreds of pages down.
        taps.first(limit) | local_taps
      end

      sig { returns(T::Array[String]) }
      def local_taps
        Tap.each.map(&:full_name).select { |full_name| File.basename(full_name).start_with?(TAP_PREFIX) }
      end

      sig { params(page: Integer).returns(T::Array[T::Hash[String, T.untyped]]) }
      def search_repositories(page)
        query = URI.encode_www_form_component(REPOSITORY_SEARCH_QUERY)
        url = "#{REPOSITORY_SEARCH_URL}?q=#{query}&sort=stars" \
              "&per_page=#{REPOSITORIES_PER_PAGE}&page=#{page}"
        ::GitHub::API.open_rest(url)["items"] || []
      end

      sig { params(taps: T::Array[String], query: String).returns(T::Array[Match]) }
      def matches(taps, query)
        needle = query.downcase
        matches = tap_files(taps).filter_map do |tap_name, path|
          name = File.basename(path, ".rb")
          rank = rank(name.downcase, needle)
          next if rank.nil?

          Match.new(name:, tap_name:, path:, rank:)
        end

        matches.sort_by! { |match| [*match.rank, match.name] }
        matches.first(MAX_RESULTS)
      end

      # Rank exact matches before prefixes, prefixes before substrings and those before typos, so
      # that searching for `foo` finds `foo` itself before `foo-bar` and `bar-foo`.
      sig { params(name: String, query: String).returns(T.nilable(T::Array[Integer])) }
      def rank(name, query)
        return [0, 0, name.length] if name == query
        return [1, 0, name.length] if name.start_with?(query)
        return [2, 0, name.length] if name.include?(query)

        # One typo per three characters, at least one, as one more matches nearly every name in a
        # corpus this size.
        distance = DidYouMean::Levenshtein.distance(name, query)
        return if distance > [query.length / 3, 1].max

        [3, distance, name.length]
      end

      # The formulae and casks of each tap, as `[tap_name, path]`.
      sig { params(taps: T::Array[String]).returns(T::Array[[String, String]]) }
      def tap_files(taps)
        files = []
        directories = taps.product(DIRECTORIES)

        (1..MAX_DIRECTORY_DEPTH).each do
          break if directories.empty?

          subdirectories = []
          requests = directories.each_slice(DIRECTORIES_PER_REQUEST).to_a
          ::Utils.parallel_map(requests) { |slice| tree_entries(slice) }.each do |entries|
            entries.each do |(tap_name, _directory), directory_entries|
              directory_entries.each do |entry|
                if entry["type"] == "tree"
                  subdirectories << [tap_name, entry["path"]]
                elsif entry["name"].end_with?(".rb")
                  files << [tap_name, entry["path"]]
                end
              end
            end
          end
          directories = subdirectories
        end

        files
      end

      # The entries of each `[tap_name, directory]`, in a request per `DIRECTORIES_PER_REQUEST`.
      sig {
        params(directories: T::Array[[String, String]])
          .returns(T::Hash[[String, String], T::Array[T::Hash[String, T.untyped]]])
      }
      def tree_entries(directories)
        fields = directories.each_with_index.map do |(tap_name, directory), i|
          owner, name = tap_name.split("/", 2)
          <<~GRAPHQL.chomp
            r#{i}: repository(owner: #{owner.inspect}, name: #{name.inspect}) {
              entries: object(expression: #{"HEAD:#{directory}".inspect}) {
                ... on Tree { entries { name path type } }
              }
            }
          GRAPHQL
        end

        # A tap can be renamed or deleted between the search and this request, so ignore errors
        # rather than failing the whole search.
        data = ::GitHub::API.open_graphql("query {\n#{fields.join("\n")}\n}", raise_errors: false)["data"]
        return {} if data.nil?

        directories.each_with_index.to_h do |directory, i|
          [directory, data.dig("r#{i}", "entries", "entries") || []]
        end
      end

      sig { params(matches: T::Array[Match]).void }
      def print_matches(matches)
        width = matches.map { |match| match.name.length }.max
        puts matches.map { |match| "#{match.name.ljust(width)}  #{match.kind.ljust(7)}  #{match.tap_name}" }
      end
    end
  end
end

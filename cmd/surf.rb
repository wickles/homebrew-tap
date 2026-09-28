# typed: strict
# frozen_string_literal: true

require "json"
require "uri"
require "utils/github/api"

module Homebrew
  module Cmd
    class Surf < AbstractCommand
      # Taps are named `homebrew-<tap>`: `Homebrew/homebrew-core`, `homebrew-ffmpeg/homebrew-ffmpeg`.
      TAP_PREFIX = "homebrew-"
      CODE_SEARCH_URL = "https://api.github.com/search/code"
      # Repeated `path:` qualifiers are OR'd and `filename:` matches a substring of the file name.
      # `extension:` keeps out files that are not formulae or casks, e.g. a tap's `README.md`.
      SEARCH_QUERY = "path:Formula/ path:Casks/ extension:rb filename:"
      # `path:` matches anywhere in the path, so this filters out vendored and test copies.
      DIRECTORY_PREFIXES = %w[Formula/ Casks/].freeze
      RESULTS_PER_PAGE = 100
      # `code_search` allows 10 requests a minute, so keep a run well inside that rather than
      # relying on the user to be patient between pages. The API never returns results beyond the
      # first 1,000 anyway.
      MAX_PAGES = 3
      MAX_LIMIT = (RESULTS_PER_PAGE * MAX_PAGES).freeze
      DEFAULT_LIMIT = 25

      class Match < T::Struct
        const :name, String
        const :tap_name, String
        const :path, String

        sig { returns(String) }
        def kind = path.start_with?("Formula/") ? "Formula" : "Cask"

        sig { returns(String) }
        def url = "https://github.com/#{tap_name}/blob/HEAD/#{path}"
      end

      cmd_args do
        description <<~EOS
          Search GitHub for formulae and casks named like <query> in any tap.

          Only repositories named like `homebrew-*` are searched, e.g. `Homebrew/homebrew-core`
          and `homebrew-ffmpeg/homebrew-ffmpeg`, and within them only the `Formula` and `Casks`
          directories. The name is matched as a substring, so `brew surf ffmpeg` finds
          `ffmpeg@6` but `brew surf ffmepg` finds nothing. A GitHub API token is required, in
          `$HOMEBREW_GITHUB_API_TOKEN`.
        EOS
        flag "--limit=",
             description: "Maximum number of matches to show, up to #{MAX_LIMIT}. " \
                          "Defaults to #{DEFAULT_LIMIT}."
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
        limit = args.limit.presence&.to_i
        limit = DEFAULT_LIMIT unless limit&.positive?
        limit = [limit, MAX_LIMIT].min
        matches = matches(query, limit)

        if args.json?
          puts JSON.pretty_generate(matches: matches.map { |match|
            { name: match.name, kind: match.kind, tap: match.tap_name, path: match.path, url: match.url }
          })
          return
        end

        odie "No formulae or casks found for #{query.inspect}." if matches.empty?

        print_matches(matches)
      end

      private

      # The `Formula` and `Casks` files named like `query` in taps, in the order GitHub returns
      # them, which puts the most prominent taps first. The filtering drops some of every page, so
      # pages are requested until there are enough matches rather than until there are enough files.
      sig { params(query: String, limit: Integer).returns(T::Array[Match]) }
      def matches(query, limit)
        matches = []
        (1..MAX_PAGES).each do |page|
          break if matches.size >= limit

          files = search_files(query, page)
          matches.concat(files.filter_map { |file| match(file) })
          break if files.size < RESULTS_PER_PAGE
        end

        matches.first(limit)
      end

      sig { params(file: T::Hash[String, T.untyped]).returns(T.nilable(Match)) }
      def match(file)
        tap_name = file.dig("repository", "full_name")
        return if tap_name.nil?
        return unless File.basename(tap_name).start_with?(TAP_PREFIX)

        path = file["path"]
        return unless path.start_with?(*DIRECTORY_PREFIXES)

        Match.new(name: File.basename(path, ".rb"), tap_name:, path:)
      end

      sig { params(query: String, page: Integer).returns(T::Array[T::Hash[String, T.untyped]]) }
      def search_files(query, page)
        search = "#{SEARCH_QUERY}#{query}"
        url = "#{CODE_SEARCH_URL}?q=#{URI.encode_www_form_component(search)}" \
              "&per_page=#{RESULTS_PER_PAGE}&page=#{page}"
        ::GitHub::API.open_rest(url)["items"] || []
      end

      sig { params(matches: T::Array[Match]).void }
      def print_matches(matches)
        width = matches.map { |match| match.name.length }.max
        puts matches.map { |match| "#{match.name.ljust(width)}  #{match.kind.ljust(7)}  #{match.tap_name}" }
      end
    end
  end
end

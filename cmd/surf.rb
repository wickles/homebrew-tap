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
      # Repeated `path:` qualifiers are OR'd, and `filename:` matches a substring of the file name.
      SEARCH_QUERY = "path:Formula/ path:Casks/ filename:"
      # `path:` matches anywhere in the path, so this filters out vendored and test copies.
      DIRECTORY_PREFIXES = %w[Formula/ Casks/].freeze
      RESULTS_PER_PAGE = 100
      MAX_RESULTS = 25

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
        matches = matches(query)

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
      # them, which puts the most prominent taps first.
      sig { params(query: String).returns(T::Array[Match]) }
      def matches(query)
        matches = search_files(query).filter_map do |file|
          tap_name = file.dig("repository", "full_name")
          next if tap_name.nil?
          next unless File.basename(tap_name).start_with?(TAP_PREFIX)

          path = file["path"]
          next unless path.start_with?(*DIRECTORY_PREFIXES)

          Match.new(name: File.basename(path, ".rb"), tap_name:, path:)
        end

        matches.first(MAX_RESULTS)
      end

      sig { params(query: String).returns(T::Array[T::Hash[String, T.untyped]]) }
      def search_files(query)
        search = "#{SEARCH_QUERY}#{query}"
        url = "#{CODE_SEARCH_URL}?q=#{URI.encode_www_form_component(search)}" \
              "&per_page=#{RESULTS_PER_PAGE}"
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

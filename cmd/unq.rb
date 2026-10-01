# typed: strict
# frozen_string_literal: true

require "cask/artifact/app"
require "cask/artifact/suite"
require "cask/cask"
require "cask/quarantine"
require "system_command"

module Homebrew
  module Cmd
    class Unq < AbstractCommand
      include SystemCommand::Mixin

      cmd_args do
        description <<~EOS
          Remove the `com.apple.quarantine` extended attribute from the apps and app suites
          installed by <cask>.

          macOS otherwise prompts, or blocks outright, on the first launch of a quarantined app.
          This is for casks whose downloads are known to be unsigned, so the prompt cannot be
          satisfied by a valid signature.
        EOS
        switch "--dry-run",
               description: "Print the apps and suites that would be unquarantined without changing anything."
        named_args :cask, min: 1
      end

      def run
        odie "Quarantine is not available on this system." unless Cask::Quarantine.available?

        args.named.to_casks.each { |cask| unquarantine_cask(cask) }
      end

      private

      sig { params(cask: Cask::Cask).void }
      def unquarantine_cask(cask)
        unless cask.installed?
          opoo "#{cask} is not installed."
          return
        end

        if (bundles = bundle_targets(cask)).empty?
          opoo "#{cask} does not install any apps or app suites."
          return
        end

        bundles.each { |bundle| unquarantine_app(bundle) }
      end

      # An `app` or `suite` artifact is moved to its target (e.g. `/Applications`) at install time,
      # so the copy in the Caskroom is not the bundle Gatekeeper evaluates. Apps that came out of a
      # suite are moved in beside it rather than into it, so both kinds are listed separately.
      sig { params(cask: Cask::Cask).returns(T::Array[Pathname]) }
      def bundle_targets(cask)
        suites = cask.artifacts.grep(Cask::Artifact::Suite).map(&:target).select(&:directory?)
        apps = cask.artifacts.grep(Cask::Artifact::App).map(&:target).select(&:directory?)
        (suites + apps).uniq.sort
      end

      sig { params(app: Pathname).void }
      def unquarantine_app(app)
        unless Cask::Quarantine.detect(app)
          puts "#{app} was not quarantined."
          return
        end

        if args.dry_run?
          puts "#{app} would be unquarantined."
          return
        end

        # Recurse: Gatekeeper evaluates the executable it is about to launch, not just the
        # bundle containing it, and quarantine is recorded on every extracted file.
        result = system_command("/usr/bin/xattr",
                                args:         ["-dr", Cask::Quarantine::QUARANTINE_ATTRIBUTE, app],
                                print_stderr: false)
        if result.success?
          puts "#{app} is now unquarantined."
        else
          onoe "Failed to unquarantine #{app}: #{result.stderr.lines.first&.strip}"
        end
      rescue ErrorDuringExecution => e
        onoe "Failed to unquarantine #{app}: #{e}"
      end
    end
  end
end

module Utils
  def self.os_version
    MacOS.version
  end

  def self.os_name
    MacOS.version.to_sym.to_s.split("_").map(&:capitalize).join
  end
end

cask "macports" do
  version "2.10.7"

  on_ventura do
    sha256 "76297f2540da91095c3c98bb6a8befc27fbb4fc69e1a289878ccb92598845371"
  end
  on_sonoma do
    sha256 "6743774b8698f98033f40ba1c033015580ad58ab67de94b25ac8cb580a2339eb"
  end
  on_sequoia do
    sha256 "fbec79aecc648596330ab0798d89f850aa08af926f1496d3e95d9b1d11011bef"
  end

  url "https://github.com/macports/macports-base/releases/download/v#{version}/MacPorts-#{version}-#{Utils.os_version}-#{Utils.os_name}.pkg",
      verified: "github.com/macports/macports-base/"
  name "MacPorts"
  desc "Package manager for building open-source software on Darwin"
  homepage "https://www.macports.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: [
    :ventura,
    :sonoma,
    :sequoia,
  ]

  pkg "MacPorts-#{version}-#{Utils.os_version}-#{Utils.os_name}.pkg"

  uninstall pkgutil: "org.macports.MacPorts"
end

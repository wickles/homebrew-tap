module Utils
  def self.os_version
    MacOS.version
  end

  def self.os_name
    MacOS.version.to_sym.to_s.split("_").map(&:capitalize).join
  end
end

cask "macports" do
  version "2.11.0"

  on_ventura do
    sha256 "40898eec50630540ae0c3abc0cb3b9d3b9d1d12428c51cf27629f9b082972e5a"
  end
  on_sonoma do
    sha256 "809da9d96c2c166ee4d7312de4006b07c49d6a4e9b448d639e4bcb9cef73c6ea"
  end
  on_sequoia do
    sha256 "3d6282321058cdab4d7214cf3b802ed1a47416f131be9087aa738e3b7874434a"
  end

  on_macos do
    url "https://github.com/macports/macports-base/releases/download/v#{version}/MacPorts-#{version}-#{Utils.os_version}-#{Utils.os_name}.pkg",
        verified: "github.com/macports/macports-base/"
  end

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

  on_macos do
    pkg "MacPorts-#{version}-#{Utils.os_version}-#{Utils.os_name}.pkg"
  end

  uninstall pkgutil: "org.macports.MacPorts"
end

module Utils
  def self.os_version
    MacOS.version
  end

  def self.os_name
    MacOS.version.to_sym.to_s.split("_").map(&:capitalize).join
  end
end

cask "macports" do
  version "2.11.5"

  on_ventura do
    sha256 "32b0a18e1549e0f11bb4182c47608b281727a090fabb2108301b2fe11cd58587"
  end
  on_sonoma do
    sha256 "3fb995fb132629c7ac22b53234c6c252e40ff5db5745f7c3d852853112342990"
  end
  on_sequoia do
    sha256 "9239720455f9ce593e3cda3d73a58fb769976cb415b5189cebbd05764e52d79b"
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

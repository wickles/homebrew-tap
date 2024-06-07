cask "macports" do
  module Utils
    def self.os_name
      MacOS.version.to_sym.to_s.split("_").map(&:capitalize).join
    end
  end

  version "2.9.3"

  on_el_capitan do
    sha256 "a2e321d698b3222e81b80b4f5dfc5d23d6d9e6b3f9de05b85bf148a9c93657a3"
  end
  on_sierra do
    sha256 "41963004bab6b73a00d6861beb083fc4be31e8ea419697e6d232e34d3d5e13a7"
  end
  on_high_sierra do
    sha256 "47fdc20239c63e039740dada5749175d788ecdc08061623404a4f5f2a530d114"
  end
  on_mojave do
    sha256 "a04d3e5b14b929bf7413742de6f0a5927b9a568a1e9d67daf19f67735c5bdb48"
  end
  on_catalina do
    sha256 "566eeab7e4c52fb300063b5a16b20a1a3dfeac4d76b5e894166991ace6285288"
  end
  on_big_sur do
    sha256 "6100cab78063791b409cdaa76de53744fa93f5f26d60878e9c0a757901763aea"
  end
  on_monterey do
    sha256 "20ce1e2a4bb5c30b0d28e9a6e33b86a1cf0a3d9d4d60861e62bf2595c550e4ed"
  end
  on_ventura do
    sha256 "6b826ab7af146b5b7011e2cc1257d27f6133945c90f3a02c150eb1fc96a4669e"
  end
  on_sonoma do
    sha256 "b5af4f2a2aca2a5a8896394a3b8967e56c6d59dffd17972b5be0369ad2830eb7"
  end

  url "https://github.com/macports/macports-base/releases/download/v#{version}/MacPorts-#{version}-#{MacOS.version}-#{Utils.os_name}.pkg",
      verified: "github.com/macports/macports-base/"
  name "MacPorts"
  desc "Package manager for building open-source software on macOS"
  homepage "https://www.macports.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: "<= :sonoma"

  pkg "MacPorts-#{version}-#{MacOS.version}-#{Utils.os_name}.pkg"

  uninstall pkgutil: "org.macports.MacPorts"
end

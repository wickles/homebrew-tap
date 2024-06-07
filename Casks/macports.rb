cask "macports" do
  module Utils
    def self.os_name
      MacOS.version.to_sym.to_s.split("_").map(&:capitalize).join
    end
  end

  version "2.8.1"

  on_el_capitan do
    sha256 "1fba6dae73235383ba87e9f1dc94be34e0e35add40a906d430ba43b250defa79"
  end
  on_sierra do
    sha256 "a33d4e7d113d7fa3bc14c4f874a340edaa0fb437ed90f8e1864986cfc2a73906"
  end
  on_high_sierra do
    sha256 "6f103815539a2b8892a77374589e2acf957cda493329b72bba1d05c7453e1cac"
  end
  on_mojave do
    sha256 "fa9369e05395cedc0540d3f03f89ce9ff226789803e10e99405ab3426624dfde"
  end
  on_catalina do
    sha256 "f360da9245bf6d124f992d7175d33bbb37eba2dc6c05aa6768460ff998d1e083"
  end
  on_big_sur do
    sha256 "99b8f955948a9ece731f3ad7ffd913e0c11a9f6d4e166949e6ffbad42c04c884"
  end
  on_monterey do
    sha256 "21b2e8e94f04897bee530d871ef83becbb48231a7107ebb9cc0e8a9063881b31"
  end
  on_ventura do
    sha256 "577512628a4b9237b3eccd0e18af28e06855f5d55bd71957c37a9c7c362de5f3"
  end
  on_sonoma do
    sha256 "3f1335efed75d541d6eca3321a3b1af9178f35ddedf585cd3896e298a9aa2a6d"
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

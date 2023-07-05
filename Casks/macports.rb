cask "macports" do
  module Utils
    def self.os_name
      return MacOS.version.to_sym.to_s.split("_").map(&:capitalize).join()
    end
  end

  version "2.7.2"
  url "https://github.com/macports/macports-base/releases/download/v#{version}/MacPorts-#{version}-#{MacOS.version}-#{Utils.os_name}.pkg",
      verified: "github.com/macports/macports-base/"
  name "MacPorts"
  desc "Package manager for building open-source software on macOS"
  homepage "https://www.macports.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_monterey do
    sha256 "9b9bc7bc552247f4d7dcb217eb5a3fc28f35e824d3769bb64e398f99d43777ea"
    depends_on macos: ">= :monterey"
  end
  on_big_sur do
    sha256 "d2ddb4e7aaa554040ee4761786baeb7a49acf80c30c06b88a79e40ac4f8c5ff8"
    depends_on macos: ">= :big_sur"
  end
  on_catalina do
    sha256 "6a82d1de0fe2db046c82a388063841ff62d6f5616a9058cc7d720515b604b64f"
    depends_on macos: ">= :catalina"
  end
  on_mojave do
    sha256 "d2e1ab88eb27a3e8335e061c056e3ffc95e0934b85e3f1d14eb6f8d44ba0ef29"
    depends_on macos: ">= :mojave"
  end
  on_high_sierra do
    sha256 "5cc55a1d32dff1a2d20149d2ba5d377018ad4951828b1b869fe90ba4df400eca"
    depends_on macos: ">= :high_sierra"
  end
  on_sierra do
    sha256 "74c42e4251799541ef85f29f6811f1d5fa1ae67cb8e318872e83031c8daa9068"
    depends_on macos: ">= :sierra"
  end

  pkg "MacPorts-#{version}-#{MacOS.version}-#{Utils.os_name}.pkg"

  uninstall pkgutil: "org.macports.MacPorts"
end

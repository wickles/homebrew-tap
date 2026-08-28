cask "omlx" do
  version "0.6.3"

  on_sequoia do
    sha256 "d56c37e55b17f478f532567016d3b2b325423234727d3036a65b491dd4030a2c"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg",
        verified: "github.com/jundot/omlx"
  end
  on_tahoe :or_newer do
    sha256 "5bde65e35c0cc3e7b0365c0e078f98d7571cb71c6a6bead591329a2cf8287537"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-27.dmg",
        verified: "github.com/jundot/omlx"
  end

  name "oMLX"
  desc "MLX server with smart caching"
  homepage "https://omlx.ai/"

  livecheck do
    url :url
    strategy :git
  end

  depends_on macos: :sequoia

  app "oMLX.app"

  # zap trash: []
end

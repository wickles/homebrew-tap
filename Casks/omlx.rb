cask "omlx" do
  version "0.6.3"
  sha256 "5bde65e35c0cc3e7b0365c0e078f98d7571cb71c6a6bead591329a2cf8287537"

  url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-27.dmg",
      verified: "github.com/jundot/omlx"
  name "oMLX"
  desc "MLX server with smart caching"
  homepage "https://omlx.ai/"

  livecheck do
    url :url
    strategy :git
  end

  # macos26 version defines the minimum OS as macos15
  depends_on macos: :sequoia

  app "oMLX.app"

  # zap trash: []
end

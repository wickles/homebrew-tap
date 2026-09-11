cask "omlx" do
  version "0.6.4"
  sha256 "53f1506c2385e8920a67198b72d1fe09351c1b3538be9c6bdeb78e5277d06d93"

  url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-27.dmg"
  name "oMLX"
  desc "MLX server with smart caching"
  homepage "https://omlx.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # macos26 version defines the minimum OS as macos15
  depends_on macos: :sequoia

  app "oMLX.app"
end

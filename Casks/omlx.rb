cask "omlx" do
  version "0.3.4"

  on_sequoia do
    sha256 "a752277766316260ce217453c9535e25bf711b4bc0ef5dd2f65b2c94a62dc289"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg",
        verified: "github.com/jundot/omlx"
  end
  on_tahoe :or_newer do
    sha256 "c1efcd8b0ce5ca84d3bca404fd69ddb178be613ee7dfd13aa449d0dc2a65025c"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-tahoe.dmg",
        verified: "github.com/jundot/omlx"
  end

  name "oMLX"
  desc "MLX server with smart caching"
  homepage "https://omlx.ai/"

  livecheck do
    url :url
    strategy :git
  end

  app "oMLX.app"

  # zap trash: []
end

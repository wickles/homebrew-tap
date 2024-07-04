cask "squirreldisk" do
  version "0.3.4"
  sha256 "45820b944d22c6190db622c214800e81496ee8f8b148557015a44e6e0f245b49"

  url "https://github.com/adileo/squirreldisk/releases/download/v#{version}/SquirrelDisk_#{version}_x64.dmg",
      verified: "github.com/adileo/squirreldisk/"
  name "SquirrelDisk"
  desc "Fast Disk Usage Analysis Tool - Built With Rust"
  homepage "https://squirreldisk.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "SquirrelDisk.app"

  zap trash: [
    "~/Library/Caches/com.squirreldisk.dev",
    "~/Library/Preferences/com.squirreldisk.dev.plist",
    "~/Library/Saved Application State/com.squirreldisk.dev.savedState",
    "~/Library/WebKit/com.squirreldisk.dev",
  ]

  caveats do
    requires_rosetta
  end
end

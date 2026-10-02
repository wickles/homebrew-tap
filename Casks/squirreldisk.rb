cask "squirreldisk" do
  version "2.5.0"
  sha256 "d9f23ff1d15ded311f45b6eb2fdaee04e2f998e4b46b48eb09e52d3c1c8d2f0a"

  url "https://github.com/adileo/squirreldisk/releases/download/v#{version}/SquirrelDisk-macOS.dmg"
  name "SquirrelDisk"
  desc "Fast Disk Usage Analysis Tool - Built With Rust"
  homepage "https://squirreldisk.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "SquirrelDisk.app"

  zap trash: [
    "~/Library/Caches/com.squirreldisk.dev",
    "~/Library/Preferences/com.squirreldisk.dev.plist",
    "~/Library/Saved Application State/com.squirreldisk.dev.savedState",
    "~/Library/WebKit/com.squirreldisk.dev",
  ]
end

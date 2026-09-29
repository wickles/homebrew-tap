cask "squirreldisk" do
  version "2.4.0"
  sha256 "6245ef7d241a722f8878c551c8708dea8278fe2d360d879311b75b25ce6cc6fc"

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

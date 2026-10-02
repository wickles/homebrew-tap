cask "betterbird" do
  arch arm: "-arm64"

  version "153.4.0esr-bb10"
  sha256 arm:   "9b81a006da056a4b6fbed6345a27902ad4aa8121bdb88be1d7fcf14345fa3a7e",
         intel: "7becb7279c1e3b73075ebed3c553a2fa03212309d4d298b69cb655f707967f93"

  url "https://www.betterbird.eu/downloads/MacDiskImage/betterbird-#{version}.en-US.mac#{arch}.dmg"
  name "Betterbird"
  desc "Fine-tuned version of Mozilla Thunderbird"
  homepage "https://www.betterbird.eu/"

  livecheck do
    url "https://www.betterbird.eu/downloads/get.php?os=mac&lang=en-US&version=release"
    regex(/betterbird-([\d.]+[\w-]*)\.en-US\.mac\.dmg/i)
    strategy :header_match
  end

  auto_updates true
  depends_on :macos

  app "Betterbird.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.mozilla.betterbird.sfl*",
    "~/Library/Caches/Thunderbird",
    "~/Library/Preferences/org.mozilla.betterbird.plist",
    "~/Library/Saved Application State/org.mozilla.betterbird.savedState",
    "~/Library/Thunderbird",
  ]

  caveats <<~EOS
    Language Packs available at https://www.betterbird.eu/downloads/index.php.
  EOS
end

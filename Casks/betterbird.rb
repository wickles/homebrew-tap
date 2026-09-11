cask "betterbird" do
  arch arm: "-arm64"

  version "153.2.0esr-bb8"
  sha256 arm:   "896769f02c2ec9cf692b473854d54bf44eee5aa17680987c3c61ac338436784e",
         intel: "fbbb170785fe6f3c45f70afe5a1af48257d5190544160c85ac9ba9ff8e5a7c92"

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

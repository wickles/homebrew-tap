cask "betterbird" do
  arch arm: "-arm64"

  version "128.13.0esr-bb31"
  sha256 arm:          "063b5a8173c24fa72ae1a21e7898f0d999637508af537fb9c2c529db29257f6b",
         intel:        "0ca5c0e573d761cb9aa1de29c40b3125030a5b6ba00ce214ef6c2190366bfc04",
         arm64_linux:  "0",
         x86_64_linux: "0"

  url "https://www.betterbird.eu/downloads/MacDiskImage/betterbird-#{version}.en-US.mac#{arch}.dmg"
  name "Betterbird"
  desc "Fine-tuned version of Mozilla Thunderbird"
  homepage "https://www.betterbird.eu/"

  livecheck do
    url "https://www.betterbird.eu/downloads/get.php?os=mac&lang=en-US&version=release"
    regex(/betterbird-([\d.]+[\w-]*)\.en-US\.mac\.dmg/i)
    strategy :header_match
  end

  # From Thunderbird system requirements.
  depends_on macos: ">= :sierra"

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

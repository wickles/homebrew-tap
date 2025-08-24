cask "betterbird" do
  arch arm: "-arm64"

  version "140.2.0esr-bb9"
  sha256 arm:          "db7a8c867f671be43a7130ef1a43517237d6c3acea6567eaf32879680d973646",
         intel:        "ae8d67545f9455591c8ddd5c921688a1832c36b5671e5b4a0f1b51f42194a0fe",
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

  auto_updates true
  depends_on macos: ">= :catalina"

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

cask "betterbird" do
  arch arm: "-arm64"

  version "153.1.0esr-bb7-build2"
  sha256 arm:          "ca7e8607fe945568f66a79d9408ef150d4d1da34530c4cc3a2d166ca660073e7",
         intel:        "18dddf819ba3fdcdcc6c9f9e50240c4e56db2ca0c686edf29695fa8f1e355cf2",
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
  depends_on macos: :catalina

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

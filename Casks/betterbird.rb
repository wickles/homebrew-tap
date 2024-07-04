cask "betterbird" do
  arch arm: "-arm64"

  version "115.12.0-bb29"
  sha256 arm:   "ab3d8b5123680817d8ffcbef504c3bc809c61662abdb451b183aeeb8f804edd8",
         intel: "bb9463ea9b08aa7e6cf346d0e374fea258d10ee3baf3274ef2b6be274a7bdb88"

  url "https://www.betterbird.eu/downloads/MacDiskImage/betterbird-#{version}.en-US.mac#{arch}.dmg"
  name "Betterbird"
  desc "Fine-tuned version of Mozilla Thunderbird"
  homepage "https://www.betterbird.eu/"

  livecheck do
    url "https://www.betterbird.eu/downloads/get.php?os=mac&lang=en-US&version=release"
    regex(/betterbird-(\d+(?:\.\d+)*-bb\d+)\.en-US\.mac\.dmg/i)
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

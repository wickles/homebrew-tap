cask "veracrypt-legacy" do
  version "1.25.9"
  sha256 "8acfdcfca5b64218431b990d1018b0c54feb508207640e819397cdbe701ae1eb"

  url "https://launchpad.net/veracrypt/trunk/#{version}/+download/VeraCrypt_#{version}.dmg",
      verified: "launchpad.net/veracrypt/trunk/"
  name "VeraCrypt"
  desc "Disk encryption software focusing on security based on TrueCrypt"
  homepage "https://www.veracrypt.fr/en/Downloads_1.25.9.html"

  livecheck do
    skip "Legacy version"
  end

  deprecate! date: "2022-02-19", because: :discontinued

  conflicts_with cask: "veracrypt"
  depends_on cask: "macfuse"

  pkg "VeraCrypt_Installer.pkg"

  uninstall pkgutil: "com.idrix.pkg.veracrypt"

  zap trash: [
    "~/Library/Application Support/VeraCrypt",
    "~/Library/Preferences/org.idrix.VeraCrypt.plist",
    "~/Library/Saved Application State/org.idrix.VeraCrypt.savedState",
  ]
end

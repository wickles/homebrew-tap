cask "dev-janitor" do
  arch arm: "aarch64", intel: "x64"

  version "2.5.0"
  sha256 arm:   "a01b9585bb300db23a089fbf90ac24af9188e8be73d2c80c0f59d585db444fd6",
         intel: "4408254895381e01d6892724d22560793e0e5892d8f6d037f0b452de928455d2"

  url "https://github.com/cocojojo5213/Dev-Janitor/releases/download/v#{version}/Dev.Janitor_#{version}_#{arch}.dmg"
  name "Dev Janitor"
  desc "Clean development artifacts and manage local developer tools"
  homepage "https://github.com/cocojojo5213/Dev-Janitor"

  livecheck do
    url :url
    strategy :git
  end

  depends_on :macos

  app "Dev Janitor.app"

  # zap trash: []
end

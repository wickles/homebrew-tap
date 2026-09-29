cask "dev-janitor" do
  arch arm: "aarch64", intel: "x64"

  version "2.5.1"
  sha256 arm:   "f5f22bf4dce5cbc791fd25da8e72828698b6ddbe8c1438fe01b0353cde3ee1cb",
         intel: "7217ab10b303e77bde1f25c4e7f4a9175b1e56b5099577adeb11ef2bf62577e3"

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

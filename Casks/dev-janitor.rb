cask "dev-janitor" do
  arch arm: "aarch64", intel: "x64"

  version "2.3.5"
  sha256 arm:          "65bb45571c55e3bec330ba1720c6d31b28174d9e58ec3fe0e6b2f9e152515429",
         intel:        "d2c3de0817b0ae660ec1dc6530a9765932f7f8a6337a0be12add1901b1cc6385",
         arm64_linux:  "0",
         x86_64_linux: "0"

  url "https://github.com/cocojojo5213/Dev-Janitor/releases/download/v#{version}/Dev.Janitor_#{version}_#{arch}.dmg"
  name "Dev Janitor"
  desc "Clean development artifacts and manage local developer tools"
  homepage "https://github.com/cocojojo5213/Dev-Janitor"

  livecheck do
    url :url
    strategy :git
  end

  app "Dev Janitor.app"

  # zap trash: []
end

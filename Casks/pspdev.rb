cask "pspdev" do
  arch arm: "latest-arm64", intel: "15-x86_64"

  version "20260801"
  sha256 arm:   "f4f603a8f1bfded1b026679aef658ff6b0a53ecd787f182cdeae91413b5f1719",
         intel: "449e8140cc6ad9eede576c462a119a1a011933181cc54f579bf62ac703e15514"

  url "https://github.com/pspdev/pspdev/releases/download/v#{version}/pspdev-macos-#{arch}.tar.gz",
      verified: "github.com/pspdev/pspdev/"
  name "pspdev"
  desc "Complete development environment for PSP homebrew"
  homepage "https://pspdev.github.io/"

  livecheck do
    url "https://github.com/pspdev/pspdev"
    strategy :github_latest
    regex(/^v?(\d+)$/i)
  end

  depends_on :macos

  binary "pspdev/bin/bin2c"
  binary "pspdev/bin/bin2o"
  binary "pspdev/bin/bin2s"
  binary "pspdev/bin/ebootsign"
  binary "pspdev/bin/mksfo"
  binary "pspdev/bin/mksfoex"
  binary "pspdev/bin/pack-pbp"
  binary "pspdev/bin/PrxEncrypter"
  binary "pspdev/bin/psp-addr2line"
  binary "pspdev/bin/psp-ar"
  binary "pspdev/bin/psp-as"
  binary "pspdev/bin/psp-build-exports"
  binary "pspdev/bin/psp-c++"
  binary "pspdev/bin/psp-c++filt"
  binary "pspdev/bin/psp-cmake"
  binary "pspdev/bin/psp-config"
  binary "pspdev/bin/psp-cpp"
  binary "pspdev/bin/psp-create-license-directory"
  binary "pspdev/bin/psp-elfedit"
  binary "pspdev/bin/psp-fixup-imports"
  binary "pspdev/bin/psp-g++"
  binary "pspdev/bin/psp-gcc"
  binary "pspdev/bin/psp-gcc-15.1.1"
  binary "pspdev/bin/psp-gcc-ar"
  binary "pspdev/bin/psp-gcc-nm"
  binary "pspdev/bin/psp-gcc-ranlib"
  binary "pspdev/bin/psp-gcov"
  binary "pspdev/bin/psp-gcov-dump"
  binary "pspdev/bin/psp-gcov-tool"
  binary "pspdev/bin/psp-gdb"
  binary "pspdev/bin/psp-gdb-add-index"
  binary "pspdev/bin/psp-gstack"
  binary "pspdev/bin/psp-ld"
  binary "pspdev/bin/psp-ld.bfd"
  binary "pspdev/bin/psp-lto-dump"
  binary "pspdev/bin/psp-makepkg"
  binary "pspdev/bin/psp-nm"
  binary "pspdev/bin/psp-objcopy"
  binary "pspdev/bin/psp-objdump"
  binary "pspdev/bin/psp-pacman"
  binary "pspdev/bin/psp-pkg-config"
  binary "pspdev/bin/psp-pkgconf"
  binary "pspdev/bin/psp-prxgen"
  binary "pspdev/bin/psp-ranlib"
  binary "pspdev/bin/psp-readelf"
  binary "pspdev/bin/psp-run"
  binary "pspdev/bin/psp-size"
  binary "pspdev/bin/psp-strings"
  binary "pspdev/bin/psp-strip"
  binary "pspdev/bin/pspsh"
  binary "pspdev/bin/unpack-pbp"
  binary "pspdev/bin/usbhostfs_pc"
end

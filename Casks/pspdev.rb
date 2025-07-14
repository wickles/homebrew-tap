cask "pspdev" do
  arch arm: "latest-arm64", intel: "13-x86_64"

  version "20250708"
  sha256 arm:          "1505dfe3208ae8fc70f15c8b12e18aa059ddf55be354c5ed6ec20d3feac709b8",
         intel:        "3c1ac1c0e682537270c9df0f8e2216d9260b3edc94d4122e00b494af943767d7",
         arm64_linux:  "0",
         x86_64_linux: "0"

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

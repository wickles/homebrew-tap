cask "root@5" do
  version "5.34.38"
  sha256 "9c3c9fc77a22a77e997a5fc66e3d32eded9c8c2ea3da1c7b7b98237c2ba25546"

  url "https://root.cern/download/root_v#{version}.macosx64-10.11-clang80.tar.gz"
  name "ROOT"
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern/"

  livecheck do
    skip "Legacy version"
  end

  conflicts_with formula: "root"

  binary "root/bin/g2root"
  binary "root/bin/genmap"
  binary "root/bin/genreflex"
  binary "root/bin/genreflex-rootcint"
  binary "root/bin/h2root"
  binary "root/bin/hadd"
  binary "root/bin/hist2workspace"
  binary "root/bin/memprobe"
  binary "root/bin/prepareHistFactory"
  binary "root/bin/proofd"
  binary "root/bin/proofserv"
  binary "root/bin/proofserv.exe"
  binary "root/bin/rlibmap"
  binary "root/bin/rmkdepend"
  binary "root/bin/root"
  binary "root/bin/root-config"
  binary "root/bin/root.exe"
  binary "root/bin/rootcint"
  binary "root/bin/rootn.exe"
  binary "root/bin/roots"
  binary "root/bin/roots.exe"
  binary "root/bin/setenvwrap.csh"
  binary "root/bin/setxrd.csh"
  binary "root/bin/setxrd.sh"
  binary "root/bin/ssh2rpd"
  binary "root/bin/thisroot.sh"
  binary "root/bin/thisroot.csh"

  caveats do
    requires_rosetta
  end
end

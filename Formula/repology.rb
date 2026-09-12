class Repology < Formula
  desc "Command-line interface for Repology.org"
  homepage "https://github.com/ibara/repology"
  url "https://github.com/ibara/repology/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "27c35bd016e51c03e564b18f518695a4b77d2c1277945dbf312d3ee0ea57870c"
  license "ISC"
  head "https://github.com/ibara/repology.git", branch: "master"

  depends_on "ldc" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "repology"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repology --version", 1)
  end
end

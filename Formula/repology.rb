class Repology < Formula
  desc "Command-line interface for Repology.org"
  homepage "https://github.com/ibara/repology"
  url "https://github.com/ibara/repology/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "961189e0d3cc8e12eee86dd3344547315541a7650a6640d78d5d73c9ff77d6c1"
  license "ISC"
  head "https://github.com/ibara/repology.git", branch: "master"

  depends_on "ldc" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "repology"
  end

  test do
    assert_match "usage: repology", shell_output("#{bin}/repology --help", 1)
  end
end

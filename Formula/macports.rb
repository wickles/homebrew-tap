class Macports < Formula
  desc "Package management system for installating software on the macOS"
  homepage "https://www.macports.org/"
  url "https://distfiles.macports.org/MacPorts/MacPorts-2.7.2.tar.bz2"
  sha256 "1c7ddb4ef819d3fdfcbb73a4ba44f7f6125cd0b764d663f097a7f834baac40f2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e9d197faa2cb6ee296902f69def0deb0dcc30db077cc6ff2943e12a5c4bdb3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4656747f66941fb5b2f4adaad2c4bdd64e99a48c1938a580f91befce75700c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "e4df4ea446eaf4b905b3e9f102a133894cb36d7b33620be03b5374fa59703975"
    sha256 cellar: :any_skip_relocation, big_sur:        "21f3aa213be2e8c0a0a2d992fb117cc5e5c5cf625b3299bcf1f7506c117900f5"
    sha256 cellar: :any_skip_relocation, catalina:       "0e86809dd3b7c95a587bc467a7b12a2ab07cacf91f31ead7174fffe3cc1d7c6f"
    sha256 cellar: :any_skip_relocation, mojave:         "d2c3aeb784d8aa8192360a20a7410b5b4f617deae10d59b18535cafa2bc5809f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7437e47f43473d9a9a81652697d21373f11346401fc7a20d0a35357ca73ea8"
  end

  option "with-dangerous-side-effects", "Enable advanced logging of all installer actions"

  def install
    if build.without? "dangerous-side-effects"
      puts <<~EOS

        This formula is highly experimental and is not recommended for general use. To install
        it anyway, you need to pass the --with-dangerous-side-effects flag.

      EOS

      exit
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-applications-dir=/Applications",
                          "--with-unsupported-prefix",
                          "--with-no-root-privileges",
                          "--with-install-user=#{ENV["USER"]}",
                          "--with-install-group=staff"
    system "make"
    system "make", "install"

    share.install prefix/"man"
  end

  def post_install
    system "#{bin}/port", "selfupdate"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/port version")
  end
end

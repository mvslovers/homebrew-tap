# Bootstrapped by hand for 2.1.0; from the next release on, libc370's
# release.yml renders this file -- edit its template in mvslovers/libc370.
class Libc370 < Formula
  desc "C library for MVS 3.8j: the cc370 target sysroot"
  homepage "https://github.com/mvslovers/libc370"
  url "https://github.com/mvslovers/libc370/releases/download/v2.1.0/libc370-2.1.0-sysroot.tar.gz"
  sha256 "17fedace4ef3e4ff70a468d81ae002e17fcc2be6c9e228be167b1dd1c0b2a1f4"
  license "BSD-2-Clause"

  def install
    # MVS target code: under libexec, which Homebrew does not link into
    # its include/ and lib/ beside the host's own C library.
    libexec.install Dir["*"]
  end

  test do
    assert_predicate libexec/"lib/libc.a", :exist?
    assert_predicate libexec/"include/sys/_cc370.h", :exist?
  end
end

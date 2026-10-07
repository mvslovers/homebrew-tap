# Rendered by libc370's release.yml for every release -- edit the template,
# sdk/homebrew/libc370.rb.in in mvslovers/libc370, not this file.
class Libc370 < Formula
  desc "C library for MVS 3.8j: the cc370 target sysroot"
  homepage "https://github.com/mvslovers/libc370"
  url "https://github.com/mvslovers/libc370/releases/download/v2.5.0/libc370-2.5.0-sysroot.tar.gz"
  sha256 "dadad68fcf69c8e75e701fc437664fa75e89e6b92587abc0e1e55ceb424a4d46"
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

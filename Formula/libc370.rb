# Rendered by libc370's release.yml for every release -- edit the template,
# sdk/homebrew/libc370.rb.in in mvslovers/libc370, not this file.
class Libc370 < Formula
  desc "C library for MVS 3.8j: the cc370 target sysroot"
  homepage "https://github.com/mvslovers/libc370"
  url "https://github.com/mvslovers/libc370/releases/download/v2.10.1/libc370-2.10.1-sysroot.tar.gz"
  sha256 "e29dc38e77b69f9bf04ef818d9d14116a91423caa594fbdd7bf4cad9e0385958"
  license "BSD-2-Clause"

  # SYS1.MACLIB and SYS1.AMODGEN, which libc370's own macros call (#490);
  # as370 finds it once cc370's formula links it in as <sysroot>/maclib370
  depends_on "mvslovers/tap/maclib370"

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

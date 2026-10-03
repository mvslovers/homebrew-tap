# Rendered by packaging/homebrew/render.sh for mvslovers/homebrew-tap (#699).
# Edit the template in mvslovers/cc370, not this file: the next release
# overwrites it.
class Cc370 < Formula
  desc "Host-native cross-toolchain for MVS 3.8j: C compiler, assembler, linker"
  homepage "https://github.com/mvslovers/cc370"
  version "1.1.1"
  license "GPL-2.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.1.1/cc370-1.1.1-darwin-arm64.tar.gz"
      sha256 "d4647b630d28efc2a9173ae5520fa8740636b4e2a080446a08d9b1fe8ec29cd6"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.1.1/cc370-1.1.1-darwin-amd64.tar.gz"
      sha256 "82a80794a17a6fcc62962b7877734e72260d3cfdc307e55cf597a340cf2d4126"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.1.1/cc370-1.1.1-linux-arm64.tar.gz"
      sha256 "0a0bdad67f9610c9d9a7153f0769b3751b144453beaa000111dc9d8461895850"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.1.1/cc370-1.1.1-linux-amd64.tar.gz"
      sha256 "6eeded7640bf177c3d4d8de0c7ebd4613480d2ecc2cf46f2efe4f62c8f111fe5"
    end
  end

  depends_on "mvslovers/tap/libc370"

  def install
    # The release tree is relocatable; the driver finds its pieces relative to
    # itself, through the bin/ symlinks Homebrew adds.
    prefix.install Dir["*"]

    # cc370 searches its sysroot only in its own tree (cc370/), so libc370's
    # files are linked in from its stable opt path: include/ whole, lib/ and
    # macros/ file by file beside cc370's own libcc370rt.a and prologue
    # macros. A file a later libc370 adds is seen after `brew reinstall cc370`
    # (cc370#726 removes the need).
    libc = Formula["mvslovers/tap/libc370"].opt_libexec
    sysroot = prefix/"cc370"
    sysroot.install_symlink libc/"include"
    Dir[libc/"lib/*", libc/"macros/*"].each do |f|
      dir = sysroot/File.basename(File.dirname(f))
      dir.install_symlink f unless (dir/File.basename(f)).exist?
    end
  end

  test do
    assert_match "cc370 1.1.1 ", shell_output("#{bin}/cc370 --version")
    (testpath/"t.c").write <<~C
      #include <stdio.h>
      int main(int argc, char **argv) { printf("%lld\\n", argc * 1000000007LL / 3); return 0; }
    C
    system bin/"cc370", "-O1", "t.c", "-o", "t"
    assert_predicate testpath/"t", :exist?
  end
end

# Rendered by packaging/homebrew/render.sh for mvslovers/homebrew-tap (#699).
# Edit the template in mvslovers/cc370, not this file: the next release
# overwrites it.
class Cc370 < Formula
  desc "Host-native cross-toolchain for MVS 3.8j: C compiler, assembler, linker"
  homepage "https://github.com/mvslovers/cc370"
  version "1.6.2"
  license "GPL-2.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.6.2/cc370-1.6.2-darwin-arm64.tar.gz"
      sha256 "09e35729ef25856cbe1534d9c96212fd3c1ffaecf37f585e813ed9eede16aad0"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.6.2/cc370-1.6.2-darwin-amd64.tar.gz"
      sha256 "1ce6758fd4a36a6aba7c4eb7b023f170913b67cae2513c410a9b829abdd3c5fa"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.6.2/cc370-1.6.2-linux-arm64.tar.gz"
      sha256 "d1eda2c2f41a868149d50b8b114424ca1857ff855242ca39bde878f85dc44cd3"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.6.2/cc370-1.6.2-linux-amd64.tar.gz"
      sha256 "15b574d10d6ca22d21e7b20c2f3352f1e82ecb68ca8684aa79fdcbbc94197eab"
    end
  end

  depends_on "mvslovers/tap/libc370"
  depends_on "mvslovers/tap/maclib370"

  def install
    # The release tree is relocatable; the driver finds its pieces relative to
    # itself, through the bin/ symlinks Homebrew adds.
    prefix.install Dir["*"]
    # lib/cc370/<version> is empty but required: the driver finds its whole
    # sysroot through a path relative to it, and Homebrew prunes empty
    # directories from a keg -- without it no header and no -lc is found.
    (lib/"cc370"/version.to_s/".keepme").write ""

    # cc370 also searches a second sysroot, cc370/libc370/{include,lib,macros}
    # (cc370#726), so libc370 is linked in whole with one symlink to its
    # stable opt path; a file a later libc370 adds is seen at once (#732).
    (prefix/"cc370").install_symlink Formula["mvslovers/tap/libc370"].opt_libexec => "libc370"
    # SYS1.MACLIB and SYS1.AMODGEN of MVS 3.8j, where as370 searches them:
    # <sysroot>/maclib370/macros, after libc370's macros.
    (prefix/"cc370").install_symlink Formula["mvslovers/tap/maclib370"].opt_libexec => "maclib370"
  end

  test do
    # Host header paths in the environment would shadow libc370's headers.
    %w[CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH].each { |v| ENV.delete(v) }
    assert_match "cc370 1.6.2 ", shell_output("#{bin}/cc370 --version")
    (testpath/"t.c").write <<~C
      #include <stdio.h>
      int main(int argc, char **argv) { printf("%lld\\n", argc * 1000000007LL / 3); return 0; }
    C
    system bin/"cc370", "-O1", "t.c", "-o", "t"
    assert_predicate testpath/"t", :exist?
    # TIME is a SYS1.MACLIB member only maclib370 carries: found with no -I
    # through the maclib370 link, rc 8 without it.
    (testpath/"t.s").write <<~ASM
      T        CSECT
               TIME  DEC
               BR    14
               END   T
    ASM
    system bin/"as370", "t.s", "-o", "t.o"
    assert_predicate testpath/"t.o", :exist?
  end
end

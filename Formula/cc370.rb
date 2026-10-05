# Rendered by packaging/homebrew/render.sh for mvslovers/homebrew-tap (#699).
# Edit the template in mvslovers/cc370, not this file: the next release
# overwrites it.
class Cc370 < Formula
  desc "Host-native cross-toolchain for MVS 3.8j: C compiler, assembler, linker"
  homepage "https://github.com/mvslovers/cc370"
  version "1.3.0"
  license "GPL-2.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.3.0/cc370-1.3.0-darwin-arm64.tar.gz"
      sha256 "7999667f3ce76f52f245f40cc7b7a9dd1180416aca45719e8fcedc64f840c4ef"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.3.0/cc370-1.3.0-darwin-amd64.tar.gz"
      sha256 "0ad853a5e2b1a28857353e606667d622dc39dc750b80c9ce996af18862ecf647"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.3.0/cc370-1.3.0-linux-arm64.tar.gz"
      sha256 "90527e551f7c46b580d2af89fbc33f9e33203f3a02f2cdf0d5a2bc44ba5c0e9d"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.3.0/cc370-1.3.0-linux-amd64.tar.gz"
      sha256 "d53e30365b60d3df0756ef0dddd449e4730c9033beacc863bf64ab363bb962cd"
    end
  end

  depends_on "mvslovers/tap/libc370"

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
  end

  test do
    # Host header paths in the environment would shadow libc370's headers.
    %w[CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH].each { |v| ENV.delete(v) }
    assert_match "cc370 1.3.0 ", shell_output("#{bin}/cc370 --version")
    (testpath/"t.c").write <<~C
      #include <stdio.h>
      int main(int argc, char **argv) { printf("%lld\\n", argc * 1000000007LL / 3); return 0; }
    C
    system bin/"cc370", "-O1", "t.c", "-o", "t"
    assert_predicate testpath/"t", :exist?
  end
end

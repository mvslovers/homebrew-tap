# Rendered by packaging/homebrew/render.sh for mvslovers/homebrew-tap (#699).
# Edit the template in mvslovers/cc370, not this file: the next release
# overwrites it.
class Cc370 < Formula
  desc "Host-native cross-toolchain for MVS 3.8j: C compiler, assembler, linker"
  homepage "https://github.com/mvslovers/cc370"
  version "1.5.0"
  license "GPL-2.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.5.0/cc370-1.5.0-darwin-arm64.tar.gz"
      sha256 "9de273eae75ab2a5e86e5a1502bf51c310184d940ae0e8b9bfe5d264ec9ffc2b"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.5.0/cc370-1.5.0-darwin-amd64.tar.gz"
      sha256 "488e4f06295371734cfd12ab8a4d5672c4c4b8c540d29df45d5e7e0ac6c1b72b"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/mvslovers/cc370/releases/download/v1.5.0/cc370-1.5.0-linux-arm64.tar.gz"
      sha256 "5e75c9620b8373ff6ed2367d863a12db2f2ec387e81efe5ae5e92b4d473382c5"
    end
    on_intel do
      url "https://github.com/mvslovers/cc370/releases/download/v1.5.0/cc370-1.5.0-linux-amd64.tar.gz"
      sha256 "b337dd8af52f5f8c78fe183e942de2f5186d0f660f8395da265e1a72524d1b33"
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
    assert_match "cc370 1.5.0 ", shell_output("#{bin}/cc370 --version")
    (testpath/"t.c").write <<~C
      #include <stdio.h>
      int main(int argc, char **argv) { printf("%lld\\n", argc * 1000000007LL / 3); return 0; }
    C
    system bin/"cc370", "-O1", "t.c", "-o", "t"
    assert_predicate testpath/"t", :exist?
  end
end

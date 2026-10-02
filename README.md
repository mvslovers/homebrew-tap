# mvslovers Homebrew tap

Homebrew formulas for the mvslovers toolchain — the cc370 cross-compiler for
MVS 3.8j and its C library, libc370. Works on macOS and on Linux through
Homebrew on Linux.

```sh
brew install mvslovers/tap/cc370
```

## Status

**No formulas yet.** They arrive with the first cc370 release that publishes
binary artifacts (mvslovers/cc370#523). Tracking issue:
[mvslovers/cc370#699](https://github.com/mvslovers/cc370/issues/699).

## How the formulas are maintained

- They install the prebuilt release tarballs of
  [cc370](https://github.com/mvslovers/cc370/releases) — one per platform
  (macOS arm64/x86_64, Linux arm64/x86_64), each checked against its SHA-256.
- The release workflows of cc370 and libc370 update `url` and `sha256` here;
  changes by hand should be the exception.
- For now the `cc370` formula also installs a matching libc370 into its own
  keg, because cc370 finds its sysroot relative to its own binary. A separate
  `libc370` formula follows once cc370 accepts an explicit sysroot.

## Other ways to install

Debian/RPM packages, tarballs and `install.sh` are attached to each
[cc370 release](https://github.com/mvslovers/cc370/releases). On Windows,
use WSL2 and the Linux artifacts.

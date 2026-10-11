# Rendered by maclib370's release.yml for every release -- edit the template,
# homebrew/maclib370.rb.in in mvslovers/maclib370, not this file.
class Maclib370 < Formula
  desc "SYS1.MACLIB and SYS1.AMODGEN of MVS 3.8j for the cc370 assembler"
  homepage "https://github.com/mvslovers/maclib370"
  url "https://github.com/mvslovers/maclib370/releases/download/v1.0.0/maclib370-1.0.0.tar.gz"
  sha256 "38bb51b15b9f2230e98ab222691f933b7122a14a6b686a915a4e4a8730effd24"
  license :cannot_represent

  def install
    # MVS target material: under libexec, where cc370 links it in as
    # <sysroot>/maclib370 (as370 searches <exedir>/../maclib370/macros).
    libexec.install Dir["*"]
  end

  test do
    assert_predicate libexec/"macros/GETMAIN.macro", :exist?
    assert_predicate libexec/"macros/CVT.macro", :exist?
  end
end

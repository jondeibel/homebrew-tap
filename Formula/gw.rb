class Gw < Formula
  desc "Git stacked branch manager"
  homepage "https://github.com/jondeibel/git-workflow"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.5/gw-aarch64-apple-darwin.tar.xz"
      sha256 "f9ecab695234d5f970e84607d734fb51a3547d43d1e0288b414e6017e8a0e40c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.5/gw-x86_64-apple-darwin.tar.xz"
      sha256 "39f2a07f626e5ef14702c4dd51a3cd482ae06996d00a483a9f40ea58cc3581fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.5/gw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fd08938a2e7f1a86b6e8cc82737e230e1ad043e85f95c8ff25f027f0ac76a42d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.5/gw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0853f0a2573ce1600e574f50bdf1e62dd2291465ecfc9db5aba8f340917d963a"
    end
  end
  license "MIT"
  depends_on "difftastic"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gw" if OS.mac? && Hardware::CPU.arm?
    bin.install "gw" if OS.mac? && Hardware::CPU.intel?
    bin.install "gw" if OS.linux? && Hardware::CPU.arm?
    bin.install "gw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

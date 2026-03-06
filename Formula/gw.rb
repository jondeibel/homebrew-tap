class Gw < Formula
  desc "Git stacked branch manager"
  homepage "https://github.com/jondeibel/git-workflow"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.2/gw-aarch64-apple-darwin.tar.xz"
      sha256 "d4ab051bad2937b8f592e18af0e6d7c3c8c20b11c474593a369a48c9c8b8da7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.2/gw-x86_64-apple-darwin.tar.xz"
      sha256 "4ac32b54b0069cae1eea7f81cc6d6d33fa5843ee46a291b0888734b4ebccc627"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.2/gw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2016b2cfca518fcf0b56be7fc25950ccd2b388bfdb42d664b3f9128e7ef4aea8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.2/gw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "989c34d1d46652e919800a21547fc5985469f70636311ae2e8c391d2634bd1a7"
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

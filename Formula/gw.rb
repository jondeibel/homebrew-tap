class Gw < Formula
  desc "Git stacked branch manager"
  homepage "https://github.com/jondeibel/git-workflow"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.1/gw-aarch64-apple-darwin.tar.xz"
      sha256 "402051636c34fe5c321ed79c0f4b9fa226079ff7fb00814ae0e4c9cfe0433763"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.1/gw-x86_64-apple-darwin.tar.xz"
      sha256 "bdd7c4a36c13ab65016e56afbddb0586ee90e8b92811ff08a63ac8fc566e5cc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.1/gw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1145843965c268ceebbdc1b19a6b1933b25d4309ac05906defa051617fac4645"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.1/gw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d9b092254e9edbfcff3840c70d5d7975fb4c6374bd7e34ed777f052c9ca32ac"
    end
  end
  license "MIT"

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

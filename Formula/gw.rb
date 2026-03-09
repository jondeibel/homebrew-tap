class Gw < Formula
  desc "Git stacked branch manager"
  homepage "https://github.com/jondeibel/git-workflow"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.3/gw-aarch64-apple-darwin.tar.xz"
      sha256 "dab3b09b2dd49fc4ca7aa9d501f67f1f2f8b7b54ca3f08302c13448fec59b731"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.3/gw-x86_64-apple-darwin.tar.xz"
      sha256 "b3100d802ce65875059185b3f67542e4e03ea2872de6c2641cf850e508748155"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.3/gw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fab292b3752a7915784dc1f3fd6970e967f271c0dacb8b4c51909bc439226fae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.3/gw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "845847258c192c4f9bb20659b4e94f11882338bf225ab57f9309b5105e17aa73"
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

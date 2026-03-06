class Gw < Formula
  desc "Git stacked branch manager"
  homepage "https://github.com/jondeibel/git-workflow"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.0/gw-aarch64-apple-darwin.tar.xz"
      sha256 "98324286efa07294f2d2b13a088c017c9bdabb095d2726065ae30b053b76254d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.0/gw-x86_64-apple-darwin.tar.xz"
      sha256 "26ad2521d797dabef79b8023a18a8c1be7e479908185eca0b3d3b8fa5d414ac4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.0/gw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7006c956f3269fc02440131590ab2f6a5fcc35c3a0e32d40587afb8a6945456c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jondeibel/git-workflow/releases/download/v0.1.0/gw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a85b33bf00bee0a72695090dfee1a82b8341320452cbc5ffa46e11f9b0c86768"
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

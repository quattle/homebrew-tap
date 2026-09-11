class Quattle < Formula
  desc "Command line for quattle, the end-to-end encrypted vault"
  homepage "https://quattle.app"
  url "https://quattle.app/cli/releases/quattle-cli-1.7.1.zip"
  sha256 "9e37e0b0c7d28a6c3f42a9a8a6a648ba7e02c81e4b302c09fd43db89fdfa50b2"
  version "1.7.1"

  depends_on "python@3.13"

  def install
    libexec.install "quattle.py", "quattle_annex.py", "vectors.json"

    python = Formula["python@3.13"].opt_bin/"python3.13"

    (bin/"quattle").write <<~SH
      #!/bin/sh
      exec "#{python}" "#{libexec}/quattle.py" "$@"
    SH

    (bin/"git-annex-remote-quattle").write <<~SH
      #!/bin/sh
      exec "#{python}" "#{libexec}/quattle_annex.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      quattle needs tokens from the Automation page of your vault:
        export QUATTLE_READ_TOKEN="..."
        export QUATTLE_WRITE_TOKEN="..."
      Then: quattle ls, quattle put <file>, quattle serve, quattle mcp
      Docs: https://quattle.app/docs
    EOS
  end

  test do
    assert_match "quattle-cli 1.7.1", shell_output("#{bin}/quattle version")
    assert_match "all vectors pass", shell_output("#{bin}/quattle test")
  end
end

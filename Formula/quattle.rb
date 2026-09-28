class Quattle < Formula
  desc "Command line for quattle, the end-to-end encrypted vault"
  homepage "https://quattle.app"
  url "https://quattle.app/cli/releases/quattle-cli-1.7.8.zip"
  sha256 "c8a5d51dca9fbb6bd2601fb9e180f00acae096f3df6a543b53f2e448af54ef99"
  version "1.7.8"

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
      quattle needs a read token and a write token from the Automation page of your vault.
      Store them with: quattle login
      Then: quattle ls, quattle put <file>, quattle serve, quattle mcp
      Docs: https://quattle.app/docs
    EOS
  end

  test do
    assert_match "quattle-cli 1.7.8", shell_output("#{bin}/quattle version")
    assert_match "all vectors pass", shell_output("#{bin}/quattle test")
  end
end

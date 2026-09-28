class Quattle < Formula
  desc "Command line for quattle, the end-to-end encrypted vault"
  homepage "https://quattle.app"
  url "https://quattle.app/cli/releases/quattle-cli-1.7.7.zip"
  sha256 "4da62cd67cfa7b95e3592d55bf3d7f13b623cf093c0f4893e24efae7ebaa2228"
  version "1.7.7"

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
    assert_match "quattle-cli 1.7.7", shell_output("#{bin}/quattle version")
    assert_match "all vectors pass", shell_output("#{bin}/quattle test")
  end
end

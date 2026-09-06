class Quattle < Formula
  desc "Command line for quattle, the end-to-end encrypted vault"
  homepage "https://quattle.app"
  url "https://quattle.app/cli/releases/quattle-cli-1.7.zip"
  sha256 "240cb4d7498de4446007351f7b75d2dc89ed579f7803ceced0490f739f5051dc"
  version "1.7"

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
    assert_match "quattle-cli 1.7", shell_output("#{bin}/quattle version")
    assert_match "all vectors pass", shell_output("#{bin}/quattle test")
  end
end

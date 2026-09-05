class Quattle < Formula
  desc "The command line tool for quattle, the end-to-end encrypted file vault."
  homepage "https://quattle.app"
  url "https://quattle.app/cli/releases/quattle-cli-1.6.1.zip"
  sha256 "4ea4c70d7b892466e4333f5defcf4e5fc6f5ea72583205075e520a1b60f50822"
  version "1.6.1"

  depends_on "python@3.13"

  def install
    libexec.install "quattle.py", "quattle_annex.py", "vectors.json"

    python = Formula["python@3.13"].opt_bin/"python3"

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
    assert_match "quattle-cli 1.6.1", shell_output("#{bin}/quattle version")
    assert_match "all vectors pass", shell_output("#{bin}/quattle test")
  end
end

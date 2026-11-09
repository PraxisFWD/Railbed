# frozen_string_literal: true

require "open3"
require "tmpdir"

RSpec.describe "bin/docs-check" do
  def run_docs_check(root)
    Open3.capture3(RbConfig.ruby, Rails.root.join("bin/docs-check").to_s, chdir: root)
  end

  def write(root, path, contents)
    full_path = File.join(root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, contents)
  end

  it "passes on the application's documentation" do
    stdout, stderr, status = run_docs_check(Rails.root.to_s)

    expect(status).to be_success, stderr
    expect(stdout).to eq("Documentation check passed.\n")
  end

  it "reports a broken link and a page missing from the docs index" do
    Dir.mktmpdir do |root|
      write(root, "AGENTS.md", "[a](ARCHITECTURE.md) [d](docs/README.md)\n")
      write(root, "ARCHITECTURE.md", "# Architecture\n")
      write(root, "docs/README.md", "[a](../ARCHITECTURE.md) [d](DOMAIN.md) [r](adr/README.md)\n")
      write(root, "docs/DOMAIN.md", "# Domain\n")
      write(root, "docs/adr/README.md", "# ADRs\n")
      write(root, "docs/guide.md", "[gone](missing.md)\n")

      _stdout, stderr, status = run_docs_check(root)

      expect(status).not_to be_success
      expect(stderr).to include("docs/guide.md: broken link `missing.md`")
      expect(stderr).to include("docs/guide.md: not linked from docs/README.md")
    end
  end
end

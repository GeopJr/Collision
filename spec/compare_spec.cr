require "./spec_helper"
require "../src/collision/functions/file_utils.cr"

describe Collision::FileUtils do
  it "returns whether the file contains one of the hashes" do
    Collision::FileUtils.compare_content(Path[__DIR__] / "test_content.txt", Collision::CLIPBOARD_HASH.values).should be_true
  end
end

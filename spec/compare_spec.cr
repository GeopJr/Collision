require "./spec_helper"
require "../src/collision/views/tools/compare.cr"

describe Collision::Compare do
  it "returns whether the file contains one of the hashes" do
    Collision::Compare.compare_content(Path[__DIR__] / "test_content.txt").should be_true
  end
end

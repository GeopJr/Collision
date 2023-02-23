require "./spec_helper"
require "../src/collision/widgets/compare.cr"

alias HashList = Array(String)

class CompareTest
  getter hash_list : Array(String) = Collision::CLIPBOARD_HASH.values

  def initialize
  end

  compare_content_macro
end

describe Collision::Widgets::Tools::Compare do
  it "returns whether the file contains one of the hashes" do
    (CompareTest.new).compare_content(Path[__DIR__] / "test_content.txt").should be_true
  end
end

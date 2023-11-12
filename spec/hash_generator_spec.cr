require "./spec_helper"
require "../src/collision/functions/checksum.cr"

describe Collision::Checksum do
  it "gets hashes from file" do
    path = Path["./spec/test.txt"].expand(home: true)
    hashes = Hash(Symbol, String).new
    channel = Channel(Hash(String, String)).new

    Collision::CLIPBOARD_HASH.keys.each do |x|
      Collision::Checksum.spawn do
        hashes[x] = Collision::Checksum.calculate(x, path.to_s)
      end
    end

    safe_stop = Time.utc.to_unix_ms
    loop do
      break if Collision::CLIPBOARD_HASH.size == hashes.size || Time.utc.to_unix_ms - safe_stop > 3000
    end

    hashes.should eq(Collision::CLIPBOARD_HASH.to_h)
  end

  it "splits strings by 4" do
    input_by_4 = "Wait ingf orso meth ingt ohap pen?"
    Collision::Checksum.split_by_4(input_by_4.split(' ').join).should eq(input_by_4)
  end
end

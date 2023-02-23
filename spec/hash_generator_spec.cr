require "./spec_helper"
require "../src/collision/functions/checksum.cr"

describe Collision::Functions::Checksum do
  checksum = Collision::Functions::Checksum.new

  it "gets hashes from file" do
    path = Path["./spec/test.txt"].expand(home: true)
    hashes = Hash(String, String).new
    channel = Channel(Hash(String, String)).new
    hash_functions = Collision::HashFunction.values

    hash_functions.each do |x|
      Collision::Functions.spawn do
        hashes[x.to_s.downcase] = checksum.calculate(x, path.to_s)
      end
    end

    safe_stop = Time.utc.to_unix_ms
    loop do
      break if hash_functions.size == hashes.size || Time.utc.to_unix_ms - safe_stop > 3000
    end

    hashes.should eq(Collision::CLIPBOARD_HASH)
  end

  it "splits strings by 4" do
    input_by_4 = "Wait ingf orso meth ingt ohap pen?"
    Collision::Functions.split_by_4(input_by_4.split(' ').join).should eq(input_by_4)
  end
end

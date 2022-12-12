require "./spec_helper"
require "../src/collision/functions/checksum.cr"

describe Collision::Checksum do
  it "gets hashes from file" do
    path = Path["./spec/test.txt"].expand(home: true)
    hashes = Hash(String, String).new
    channel = Channel(Hash(String, String)).new
    hash_functions = ["sha512", "sha256", "md5", "sha1"]

    hash_functions.each do |x|
      Collision::Checksum.spawn do
        hashes[x] = Collision::Checksum.calculate(x, path.to_s)
      end
    end

    safe_stop = Time.utc.to_unix_ms
    loop do
      break if hash_functions.size == hashes.size || Time.utc.to_unix_ms - safe_stop > 3000
    end

    hashes.should eq(Collision::CLIPBOARD_HASH)
  end
end

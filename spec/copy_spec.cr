require "./spec_helper"
require "../src/modules/functions/generate_hash.cr"

describe "hash generator" do
  it "gets hashes from file" do
    path = Path["./spec/test.txt"].expand(home: true)
    hashes = Hash(String, String).new
    channel = Channel(Hash(String, String)).new
    hash_functions = ["sha512", "sha256", "md5", "sha1"]

    hash_functions.each do |x|
      Collision.handle_spawning do
        hashes[x] = Collision.calculate_hash(x, path.to_s)
      end
    end

    safe_stop = Time.utc.to_unix_ms
    loop do
      break if hash_functions.size == hashes.size || Time.utc.to_unix_ms - safe_stop > 3000
    end

    hashes.should eq({"md5" => "f7e3f382f0382147661c82af20e274e8", "sha1" => "c8f0b71214e8164aa69419b7ac0bcd8a74f529a6", "sha256" => "08e3dfc089e66c44ae8abd3476b0f810f11f4cfc2ab925f1607c7df21345d639", "sha512" => "2ddb9cca7753a01fcbcdbacc228ae8c314ff4e735c6fffb42286272fb460930dc74f122a9f365053a13016b22403ad4e192142e8668bc5f7d6fce865eb38ec2c"})
  end
end

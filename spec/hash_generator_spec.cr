require "./spec_helper"
require "../src/collision/functions/checksum.cr"

describe Collision::Checksum do
  it "gets hashes from file" do
    path = Path["./spec/test.txt"].expand(home: true)
    hashes = Hash(Symbol, String).new
    channel = Channel(Hash(String, String)).new
    {% if Fiber::ExecutionContext.has_constant?(:Parallel) %}
      mt_context = Fiber::ExecutionContext::Parallel.new("worker-threads", 8)
    {% else %}
      mt_context = Fiber::ExecutionContext::MultiThreaded.new("worker-threads", 8)
    {% end %}

    Collision::CLIPBOARD_HASH.keys.each do |x|
      hashes[x] = ""
      mt_context.spawn do
        hashes[x] = Collision::Checksum.new.calculate(x, path.to_s)
      end
    end

    safe_stop = Time.utc.to_unix_ms
    loop do
      break if Collision::CLIPBOARD_HASH.keys.size == hashes.reject { |k, v| v == "" }.keys.size || Time.utc.to_unix_ms - safe_stop > Collision::CLIPBOARD_HASH.size * 5000
    end

    Collision::CLIPBOARD_HASH.each do |k, v|
      {k, hashes[k]}.should eq({k, v})
    end
  end

  it "splits strings by 4" do
    input_by_4 = "Wait ingf orso meth ingt ohap pen?"
    Collision.split_by_4(input_by_4.split(' ').join).should eq(input_by_4)
  end
end

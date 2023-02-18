require "openssl"
require "non-blocking-spawn"

macro gen_digest
  {
    {% for hash in Collision::HASH_FUNCTIONS %}
      {{hash.downcase}} => OpenSSL::Digest.new({{hash.upcase}}),
    {% end %}
  }
end

module Collision::Checksum
  extend self

  @@digest = gen_digest
  @@channel = Channel(Tuple(String, String)).new

  def split_by_4(hash_str : String)
    i = 0
    input = hash_str.byte_slice?(i * 4, 4)
    String.build do |str|
      loop do
        str << input
        i = i + 1
        input = hash_str.byte_slice?(i * 4, 4)
        break if input.nil? || input.empty?
        str << ' '
      end
    end
  end

  def calculate(type : String, filename : String) : String
    hash = @@digest[type.downcase]
    hash.reset
    hash.file(filename).final.hexstring.downcase
  end

  def spawn(&block)
    Non::Blocking.spawn(same_thread: false, &block)
  end

  def on_finished(res : Hash(String, String), &block)
    yield res
  end

  def generate(filename : String, &block : Hash(String, String) ->)
    hash_amount = HASH_FUNCTIONS.size
    HASH_FUNCTIONS.each_with_index do |hash_type, i|
      proc = ->(fiber_no : Int32) do
        Collision::Checksum.spawn do
          LOGGER.debug { "Spawned fiber #{hash_type}" }

          hash_value = calculate(hash_type, filename)
          # hash_list.set_hash(hash_type, split_by_4(hash_value))
          LOGGER.debug { "Finished fiber #{fiber_no + 1}/#{hash_amount}" }

          @@channel.send({hash_type, split_by_4(hash_value)})
        end
      end
      proc.call(i)
    end

    Collision::Checksum.spawn do
      hash_hash = Hash(String, String).new
      hash_amount.times do |i|
        res = @@channel.receive
        hash_hash[res[0]] = res[1]
      end

      on_finished(hash_hash, &block)
    end
  end
end

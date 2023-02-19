require "openssl"
require "non-blocking-spawn"

macro gen_digest
  {
    {% for hash in Collision::HashFunction.constants %}
      Collision::HashFunction::{{hash}} => OpenSSL::Digest.new("{{hash.downcase}}"),
    {% end %}
  }
end

module Collision::Functions
  HASH_FUNCTIONS_SIZE = {{HashFunction.constants.size}}

  # Splits a string every 4 characters (fast).
  def self.split_by_4(hash_str : String)
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

  def self.spawn(&block)
    Non::Blocking.spawn(same_thread: false, &block)
  end

  class Checksum
    @digest : Hash(Collision::HashFunction, OpenSSL::Digest) = gen_digest
    @channel = Channel(Tuple(HashFunction, String, String)).new

    def initialize
    end

    def calculate(type : HashFunction, filename : String) : String
      hash = @digest[type]
      hash.reset
      hash.file(filename).final.hexstring.downcase
    end

    def on_finished(res : Hash(HashFunction, Tuple(String, String)), &block)
      yield res
    end

    def generate(filename : String, &block : Hash(HashFunction, Tuple(String, String)) ->)
      HashFunction.values.each_with_index do |hash_type, i|
        proc = ->(fiber_no : Int32) do
          Collision::Functions.spawn do
            LOGGER.debug { "Spawned fiber #{hash_type}" }

            hash_value = calculate(hash_type, filename)
            LOGGER.debug { "Finished fiber #{fiber_no + 1}/#{HASH_FUNCTIONS_SIZE}" }

            @channel.send({hash_type, Collision::Functions.split_by_4(hash_value), hash_value})
          end
        end
        proc.call(i)
      end

      Collision::Functions.spawn do
        hash_hash = Hash(HashFunction, Tuple(String, String)).new
        HASH_FUNCTIONS_SIZE.times do |i|
          res = @channel.receive
          hash_hash[res[0]] = {res[1], res[2]}
        end

        on_finished(hash_hash, &block)
      end
    end
  end
end

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
  @@channel = Channel(Nil).new

  def calculate(type : String, filename : String) : String
    hash = @@digest[type.downcase]
    hash.reset
    hash.file(filename).final.hexstring.downcase
  end

  def spawn(&block)
    Non::Blocking.spawn(same_thread: false, &block)
  end

  def on_finished(&block)
    yield
  end

  def generate(filename : String, &block)
    hash_amount = ACTION_ROWS.keys.size
    ACTION_ROWS.keys.each_with_index do |hash_type, i|
      proc = ->(fiber_no : Int32) do
        Collision::Checksum.spawn do
          LOGGER.debug { "Spawned fiber #{hash_type}" }

          hash_value = calculate(hash_type, filename)
          ACTION_ROWS[hash_type].subtitle = hash_value.gsub(/.{1,4}/) { |x| x + " " }[0..-2]
          CLIPBOARD_HASH[hash_type] = hash_value
          LOGGER.debug { "Finished fiber #{fiber_no + 1}/#{hash_amount}" }

          @@channel.send(nil)
        end
      end
      proc.call(i)
    end

    Collision::Checksum.spawn do
      hash_amount.times do |i|
        @@channel.receive
      end

      on_finished(&block)
    end
  end
end

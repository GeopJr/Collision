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

  def split_by_4(hash_str : String)
    io = IO::Memory.new(hash_str)

    res = [] of String
    while !(str = io.gets(4)).nil?
      res << str
    end

    res.join(' ')
  end

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
          ACTION_ROWS[hash_type].subtitle = split_by_4(hash_value)
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

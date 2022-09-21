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
  @@finished_fibers = 0

  def calculate(type : String, filename : String) : String
    hash = @@digest[type.downcase]
    hash.reset
    hash.file(filename).final.hexstring.downcase
  end

  def spawn(&block)
    Non::Blocking.spawn(same_thread: false, &block)
  end

  def on_finished(&block)
    LOGGER.debug { "Finished fiber #{@@finished_fibers}/#{ACTION_ROWS.keys.size}" }

    yield if @@finished_fibers == ACTION_ROWS.keys.size
  end

  def generate(filename : String, &block)
    @@finished_fibers = 0
    ACTION_ROWS.keys.each do |hash_type|
      Collision::Checksum.spawn do
        LOGGER.debug { "Spawned fiber #{hash_type}" }

        hash_value = calculate(hash_type, filename)
        ACTION_ROWS[hash_type].subtitle = hash_value.gsub(/.{1,4}/) { |x| x + " " }[0..-2]
        CLIPBOARD_HASH[hash_type] = hash_value
        @@finished_fibers += 1

        on_finished(&block)
      end
    end
  end
end

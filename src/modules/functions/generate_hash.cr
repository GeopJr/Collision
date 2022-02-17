require "openssl"
require "non-blocking-spawn"

macro gen_digest
  {
    {% for hash in Hashbrown::HASH_FUNCTIONS %}
      {{hash.downcase}} => OpenSSL::Digest.new({{hash.upcase}}),
    {% end %}
  }
end

module Hashbrown
  extend self

  @@digest = gen_digest
  @@finished_fibers = 0

  def calculate_hash(type : String, filename : String) : String
    hash = @@digest[type.downcase]
    hash.reset
    hash.file(filename).final.hexstring.downcase
  end

  # If there are more than one threads available (except the current one),
  # spawn fibers else just run in sync.
  def handle_spawning(&block)
    if Non::Blocking.threads.size <= 1
      yield
    else
      Non::Blocking.spawn(same_thread: false, &block)
    end
  end

  def on_finished(&block)
    @@finished_fibers += 1
    yield if @@finished_fibers == ACTION_ROWS.keys.size
  end

  def generate_hashes(filename : String, &block)
    @@finished_fibers = 0
    ACTION_ROWS.keys.each do |hash_type|
      handle_spawning do
        hash_value = calculate_hash(hash_type, filename)
        ACTION_ROWS[hash_type].subtitle = hash_value.gsub(/.{1,4}/) { |x| x + " " }[0..-2]
        CLIPBOARD_HASH[hash_type] = hash_value
        on_finished(&block)
      end
    end
  end
end

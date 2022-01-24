require "openssl"

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

  def run_cmd(cmd, args) : String
    stdout = IO::Memory.new
    stderr = IO::Memory.new
    status = Process.run(cmd, args: args, output: stdout, error: stderr)

    output = stderr.to_s.size == 0 ? stdout.to_s : stderr.to_s
    output
  end

  def calculate_hash(type : String, filename : String) : String
    hash = @@digest[type.downcase]
    hash.reset
    hash.file(filename).final.hexstring.downcase
  end

  def generate_hashes(filename : String)
    spawn do
      ACTION_ROWS.keys.each do |k|
        hash_type = k
        hash_value = calculate_hash(k, filename)
        ACTION_ROWS[hash_type].subtitle = hash_value.gsub(/.{1,4}/) { |x| x + " " }[0..-2]
        CLIPBOARD_HASH[hash_type] = hash_value
      end
    end
  end
end

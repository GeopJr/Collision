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

  def calculate_hash(type : String, filename : String, channel : Channel(Hash(String, String))) : Channel(Hash(String, String))
    hash = @@digest[type.downcase]
    hash.reset
    channel.send({type.upcase => hash.file(filename).final.hexstring.downcase})
  end

  def generate_hashes(filename : String)
    tempBtns = Hash(Gtk::Button, String).new
    channel = Channel(Hash(String, String)).new

    ACTION_ROWS.keys.each do |k|
      spawn(calculate_hash("#{k}", filename, channel))
    end

    ACTION_ROWS.keys.each do |_|
      output = channel.receive
      hash_type = output.keys.first
      hash_value = output[hash_type]
      ACTION_ROWS[hash_type].subtitle = hash_value.gsub(/.{1,4}/) { |x| x + " " }[0..-2]
      CLIPBOARD_HASH[hash_type] = hash_value
    end
  end
end

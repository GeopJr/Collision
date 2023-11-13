require "non-blocking-spawn"
require "digest/md5"
require "digest/sha1"
require "digest/sha256"
require "digest/sha512"
require "digest/crc32"
require "digest/adler32"
require "blake3"

macro gen_digest
  {
    {% for title, digest in Collision::HASH_FUNCTIONS %}
      :{{title}} => Digest::{{digest.id}}.new,
    {% end %}
  }
end

module Collision::Checksum
  extend self

  @@digest = gen_digest
  @@channel = Channel(Tuple(Symbol, String)).new

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

  def calculate(type : Symbol, filename : String) : String
    hash = @@digest[type]
    hash.reset
    hash.file(filename).final.hexstring.downcase
  end

  def spawn(&block)
    Non::Blocking.spawn(same_thread: false, &block)
  end

  def on_finished(res : Hash(Symbol, String), &block)
    yield res
  end

  def generate(filename : String, progressbar : Gtk::ProgressBar? = nil, &block : Hash(Symbol, String) ->)
    hash_amount = Collision::HASH_FUNCTIONS.size
    Collision::HASH_FUNCTIONS.each_with_index do |hash_key, hash_value, i|
      proc = ->(fiber_no : Int32) do
        Collision::Checksum.spawn do
          LOGGER.debug { "Spawned fiber #{hash_value}" }

          hash_value = calculate(hash_key, filename)
          LOGGER.debug { "Finished fiber #{fiber_no + 1}/#{hash_amount}" }

          @@channel.send({hash_key, hash_value})
        end
      end
      proc.call(i)
    end

    Collision::Checksum.spawn do
      res = Hash(Symbol, String).new
      step = 1/hash_amount
      hash_amount.times do |i|
        t_res = @@channel.receive
        res[t_res[0]] = t_res[1]

        unless progressbar.nil?
          progressbar.fraction = Math.min(progressbar.fraction + step, 1.0)
          progressbar.text = sprintf(Gettext.gettext("%d of %d hashes calculated"), {i + 1, hash_amount})
        end
      end

      on_finished(res, &block)
    end
  end
end

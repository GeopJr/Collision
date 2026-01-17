require "digest/md5"
require "digest/sha1"
require "digest/sha256"
require "digest/sha512"
require "digest/crc32"
require "digest/adler32"
require "blake3"

module Collision
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

  class Checksum
    @mt_context : Fiber::ExecutionContext::Parallel = Fiber::ExecutionContext::Parallel.new("worker-threads", 8)
    @s_context = Fiber::ExecutionContext::Concurrent.new("channel-receiver")

    def calculate(type : Symbol, filename : String) : String
      hash =
        {% begin %}
        case type
        {% for title, digest in Collision::HASH_FUNCTIONS %}
          when :{{title}} then Digest::{{digest.id}}.new
        {% end %}
        else
          raise "no digest for #{type}" # shouldn't be reached
        end
      {% end %}
      hash.file(filename).hexfinal.downcase
    end

    def initialize
    end

    def generate(filename : String, progressbar : Gtk::ProgressBar? = nil, &block : Hash(Symbol, String) ->)
      hash_amount = Collision::HASH_FUNCTIONS.size

      unless progressbar.nil?
        progressbar.fraction = 0.0
        progressbar.text = sprintf(Gettext.gettext("%d of %d hashes calculated"), {0, hash_amount})
      end

      atomic = Atomic.new(0)
      step = 1/hash_amount
      res = Hash(Symbol, String).new
      channel = Channel(Tuple(Symbol, String)).new(hash_amount)
      Collision::HASH_FUNCTIONS.each_with_index do |hash_key, hash_value, i|
        @mt_context.spawn do
          LOGGER.debug { "Spawned fiber #{hash_value}" }
          calculated_hash = calculate(hash_key, filename)
          LOGGER.debug { "Finished fiber #{i + 1}/#{hash_amount}" }

          atomic.add(1)
          GLib.idle_add do
            unless progressbar.nil?
              progressbar.fraction = Math.min(progressbar.fraction + step, 1.0)
              progressbar.text = sprintf(Gettext.gettext("%d of %d hashes calculated"), {atomic.get, hash_amount})
            end
            false
          end

          channel.send({hash_key, calculated_hash})
        end
      end

      @s_context.spawn do
        res = Hash(Symbol, String).new
        hash_amount.times do |i|
          t_res = channel.receive
          res[t_res[0]] = t_res[1]
        end
        block.call(res)
      end
    end
  end
end

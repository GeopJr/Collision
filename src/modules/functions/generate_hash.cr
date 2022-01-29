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
  @@finished_fibers = 0

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

  # This is a fork of top level spawn,
  # but when same_thread is false, it makes sure
  # that the fiber spawns in any worker thread BUT the current one.
  # If only the current one is available, it falls back to leaving it to
  # Crystal::Scheduler to decide.
  #
  # https://crystal-lang.org/api/1.3.2/toplevel.html#spawn%28%2A%2Cname%3AString%3F%3Dnil%2Csame_thread%3Dfalse%2C%26block%29-class-method
  # https://github.com/crystal-lang/crystal/blob/932f193ae/src/concurrent.cr#L60-L67
  def non_blocking_spawn(*, name : String? = nil, same_thread = false, &block) : Fiber
    fiber = Fiber.new(name, &block)
    if same_thread
      fiber.@current_thread.set(Thread.current)
    else
      threads = non_blocking_threads
      # If there are threads available other than the current one,
      # set fiber's thread as a random one from the array.
      fiber.@current_thread.set(threads.sample) unless threads.size == 0
    end
    Crystal::Scheduler.enqueue fiber
    fiber
  end

  # Get all threads that are not the current one.
  def non_blocking_threads : Array(Thread)
    threads = [] of Thread
    Thread.unsafe_each do |thread|
      next if thread == Thread.current
      threads << thread
    end
    threads
  end

  # If there are more than one threads available (except the current one),
  # spawn fibers else just run in sync.
  def handle_spawning(&block)
    if non_blocking_threads.size == 0
      yield
    else
      non_blocking_spawn(same_thread: false, &block)
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

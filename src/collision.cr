require "./license.cr"
require "libadwaita"
require "gettext"
require "log"

if Non::Blocking.threads.size == 0
  STDERR.puts "App is running in single-threaded mode. Exiting."
  exit(1)
end

module Collision
  # Enable debug logs if debug build or --debug is passed.
  # Also save a copy in memory for the About window troubleshooting
  # section.
  TROUBLESHOOTING = IO::Memory.new

  # Some basic info
  TROUBLESHOOTING << <<-DEBUG
  flatpak: #{{{!env("FLATPAK_ID").nil? || file_exists?("/.flatpak-info")}}}
  release: #{{{flag?(:release)}}}
  debug: #{{{flag?(:debug)}}}
  version: #{VERSION}
  crystal: #{Crystal::VERSION}
  gtk: #{Gtk.major_version}.#{Gtk.minor_version}.#{Gtk.micro_version} (#{Gtk::MAJOR_VERSION}.#{Gtk::MINOR_VERSION}.#{Gtk::MICRO_VERSION})
  libadwaita: #{Adw.major_version}.#{Adw.minor_version}.#{Adw.micro_version} (#{Adw::MAJOR_VERSION}.#{Adw::MINOR_VERSION}.#{Adw::MICRO_VERSION})
  DEBUG

  if {{ flag?(:debug) || !flag?(:release) }} || ARGV[0]? == "--debug"
    TROUBLESHOOTING << "\n\n"

    Log.setup do |c|
      backend = Log::IOBackend.new

      c.bind "Collision", :debug, backend
      c.bind "Collision", :debug, Log::IOBackend.new(TROUBLESHOOTING)
      c.bind "Collision", :warn, backend
    end
  end

  LOGGER = Log.for("Collision", ({{ flag?(:debug) || !flag?(:release) }} || ARGV[0]? == "--debug") ? Log::Severity::Debug : Log::Severity::Warn)

  # We want to __not__ load settings on dev/debug mode or when -Ddisable_gschema is passed or when
  # -Denable_gschema is __not__ passed.
  # -Denable_gschema is used for when you are in dev/debug mode and want to enable it.
  # -Ddisable_gschema is used for when you are in prod mode and want to disable it (for package maintainers).
  SETTINGS = {% if (flag?(:debug) || !flag?(:release) || flag?(:disable_gschema)) && !flag?(:enable_gschema) %}
               nil
             {% else %}
               Gio::Settings.new("dev.geopjr.Collision")
             {% end %}

  begin
    Gettext.setlocale(Gettext::LC::ALL, "")
    Gettext.bindtextdomain("dev.geopjr.Collision", {{env("COLLISION_LOCALE_LOCATION").nil? ? "/usr/share/locale" : env("COLLISION_LOCALE_LOCATION")}})
    Gettext.textdomain("dev.geopjr.Collision")
  rescue ex
    LOGGER.debug { ex }
  end

  enum HashFunction
    MD5
    SHA1
    SHA256
    SHA512
  end

  VERSION = {{read_file("#{__DIR__}/../shard.yml").split("version: ")[1].split("\n")[0]}} # Shards binary might not be in PATH, reading yml is safer

  ARTICLE = Gettext.gettext("https://en.wikipedia.org/wiki/Comparison_of_cryptographic_hash_functions")

  Gio.register_resource("data/dev.geopjr.Collision.gresource.xml", "data")
end

require "./collision/*"
require "./collision/actions/*"
require "./collision/functions/*"
require "./collision/widgets/*"
require "./collision/views/*"

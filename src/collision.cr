require "./license.cr"
require "libadwaita"
require "gettext"
require "log"

module Collision
  @@activated = false

  def self.activated
    @@activated
  end

  def self.activated=(activated : Bool)
    @@activated = activated
  end

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

  HASH_FUNCTIONS = {
    md5:     "MD5",
    sha1:    "SHA1",
    sha256:  "SHA256",
    sha512:  "SHA512",
    blake3:  "Blake3",
    crc32:   "CRC32",
    adler32: "Adler32",
  }
  VERSION = {{read_file("#{__DIR__}/../shard.yml").split("version: ")[1].split("\n")[0]}} # Shards binary might not be in PATH, reading yml is safer

  ARTICLE = Gettext.gettext("https://en.wikipedia.org/wiki/Comparison_of_cryptographic_hash_functions")

  Gio.register_resource("data/dev.geopjr.Collision.gresource.xml", "data")
end

require "./collision/*"

# Creates and setups a window. If a file is passed it will attempt to open it.
def activate_with_file(app : Adw::Application, file : Gio::File? = nil)
  window = Collision::Window.new
  window.application = app

  # Save settings on close
  window.close_request_signal.connect(->Collision::Settings.save(Gtk::Window))
  # Load settings
  window_settings = Collision.settings
  window.set_default_size(window_settings[:window_width], window_settings[:window_height])
  window.maximize if window_settings[:window_maximized]

  # Devel styling
  {% if flag?(:debug) || !flag?(:release) %}
    window.add_css_class("devel")
  {% end %}

  window.present
  Collision::LOGGER.debug { "Window activated" }
  Collision::LOGGER.debug { "Settings: #{window_settings}" }
  Collision.activated = true

  unless file.nil?
    Collision::LOGGER.debug { "Activating with file" }

    window.loading
    window.file = file
  end
end

# Wrapper around activate_with_file
# but without a file
def activate(app : Adw::Application)
  activate_with_file(app)
end

# Handles the open signal.
# If there are no files passed, it calls activate,
# else it calls activate_with_file for each file
def open_with(app : Adw::Application, files : Enumerable(Gio::File), hint : String)
  if files.empty?
    activate(app)
  else
    open_files(app, files)
  end

  nil
end

def open_files(app : Adw::Application, files : Enumerable(Gio::File))
  files.each do |file|
    next unless !(file_path = file.path).nil? && Collision::FileUtils.file?(file_path)
    if Collision.activated
      GLib.idle_add do
        activate_with_file(app, file)
        false
      end
    else
      activate_with_file(app, file)
    end
  end
end

def startup(app : Adw::Application)
  # Setup actions
  Collision::Action::HashInfo.new(app)
  Collision::Action::About.new(app)
  Collision::Action::NewWindow.new(app)
  Collision::Action::Quit.new(app)
  app.set_accels_for_action("win.open-file", {"<Ctrl>O"})
  app.set_accels_for_action("window.close", {"<Ctrl>W"})
end

# ARGV but without flags, passed to Application.
gtk = Fiber::ExecutionContext::Isolated.new("Gtk") do
  app = Adw::Application.new("dev.geopjr.Collision", Gio::ApplicationFlags::HandlesOpen)
  clean_argv = [PROGRAM_NAME].concat(ARGV.reject { |x| x.starts_with?('-') })
  app.startup_signal.connect(->startup(Adw::Application))
  app.activate_signal.connect(->activate(Adw::Application))
  app.open_signal.connect(->open_with(Adw::Application, Enumerable(Gio::File), String))
  app.run(clean_argv)
end
gtk.wait

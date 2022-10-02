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

  HASH_FUNCTIONS = {"MD5", "SHA1", "SHA256", "SHA512"}
  VERSION        = {{read_file("#{__DIR__}/../shard.yml").split("version: ")[1].split("\n")[0]}} # Shards binary might not be in PATH, reading yml is safer

  ARTICLE = Gettext.gettext("https://en.wikipedia.org/wiki/Comparison_of_cryptographic_hash_functions")

  Gio.register_resource("data/dev.geopjr.Collision.gresource.xml", "data")
end

require "./collision/actions/*"
require "./collision/functions/*"
require "./collision/views/*"
require "./collision/views/tools/*"

macro gen_hash(buttons)
  {
  {% for hash, index in Collision::HASH_FUNCTIONS %}
    {{hash.upcase}} => {% if buttons %} Gtk::Button.cast(B_HS["copyBtn{{index + 1}}"]) {% else %} Adw::ActionRow.cast(B_HS["hashRow{{index + 1}}"]) {% end %},
  {% end %}
  }
end

module Collision
  B_UI = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/welcomer.ui")
  B_HL = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/header_left.ui")
  B_HR = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/header_right.ui")
  B_HS = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/hash_list.ui")
  B_TL = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/tools.ui")
  B_HT = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/switcher.ui")
  B_SP = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/spinner.ui")
  B_FI = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/file_info.ui")

  WINDOW_BOX = Gtk::Box.new(Gtk::Orientation::Vertical, 0)

  WELCOME_BUTTON               = Gtk::Button.cast(B_UI["welcomeBtn"])
  OPEN_FILE_BUTTON             = Gtk::Button.cast(B_HL["openFileBtn"])
  MENU_BUTTON                  = Gtk::MenuButton.cast(B_HR["menuBtn"])
  MAIN_FILE_CHOOSER_NATIVE     = Gtk::FileChooserNative.cast(B_HL["mainFileChooserNative"])
  WELCOMER_FILE_CHOOSER_NATIVE = Gtk::FileChooserNative.cast(B_UI["welcomerFileChooserNative"])
  HEADER_TITLE                 = Adw::ViewSwitcherTitle.cast(B_HT["switcher_title"])
  BOTTOM_TABS                  = Adw::ViewSwitcherBar.cast(B_HT["switcher_bar"])
  STACK                        = Adw::ViewStack.cast(B_HT["stack"])

  SPINNER = Gtk::Spinner.new(
    spinning: true,
    halign: Gtk::Align::Center,
    vexpand: true,
    hexpand: true,
    width_request: 32,
    height_request: 32
  )
  TOOL_COMPARE_BUTTON_SPINNER = Gtk::Spinner.new(
    spinning: true,
    halign: Gtk::Align::Center,
    width_request: 36,
    height_request: 36,
    visible: false
  )
  TOOL_VERIFY_INPUT = Gtk::TextView.new(
    pixels_above_lines: 11,
    pixels_below_lines: 11,
    left_margin: 5,
    right_margin: 5,
    cursor_visible: false,
    height_request: 125,
    wrap_mode: Gtk::WrapMode::Char,
    accepts_tab: false,
    css_name: "entry",
    css_classes: ["card-like", "monospace"],
    tooltip_text: Gettext.gettext("Insert a MD5/SHA-1/SHA-256/SHA-512 Hash")
  )

  TOOLS_GRID                       = Gtk::Grid.cast(B_TL["tools"])
  TOOL_VERIFY_OVERLAY              = Gtk::Overlay.cast(B_TL["verifyOverlay"])
  TOOL_VERIFY_OVERLAY_LABEL        = Gtk::Label.cast(B_TL["verifyOverlayLabel"])
  TOOL_VERIFY_FEEDBACK             = Gtk::Image.cast(B_TL["verifyFeedback"])
  TOOL_COMPARE_BUTTON              = Gtk::Button.cast(B_TL["compareBtn"])
  TOOL_COMPARE_BUTTON_IMAGE        = Gtk::Image.cast(B_TL["compareBtnImage"])
  TOOL_COMPARE_BUTTON_LABEL        = Gtk::Label.cast(B_TL["compareBtnLabel"])
  TOOL_COMPARE_BUTTON_FEEDBACK     = Gtk::Box.cast(B_TL["compareBtnFeedback"])
  TOOL_COMPARE_FILE_CHOOSER_NATIVE = Gtk::FileChooserNative.cast(B_TL["compareFileChooserNative"])

  COPY_BUTTONS   = gen_hash(true)
  CLIPBOARD_HASH = Hash(String, String).new
  ACTION_ROWS    = gen_hash(false)

  FILE_INFO = Adw::StatusPage.cast(B_FI["fileInfo"])
  HASH_LIST = Gtk::ListBox.cast(B_HS["hashList"])

  APP = Adw::Application.new("dev.geopjr.Collision", Gio::ApplicationFlags::None)
end

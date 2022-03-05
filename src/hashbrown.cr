require "libadwaita"
require "compiled_license"
require "gettext"
require "log"

require "./modules/prerequisites.cr"
require "./modules/functions/*"
require "./modules/views/*"
require "./modules/views/tools/*"

macro gen_hash(buttons)
  {
  {% for hash, index in Hashbrown::HASH_FUNCTIONS %}
    {{hash.upcase}} => {% if buttons %} Gtk::Button.cast(B_HS["copyBtn{{index + 1}}"]) {% else %} Adw::ActionRow.cast(B_HS["hashRow{{index + 1}}"]) {% end %},
  {% end %}
  }
end

module Hashbrown
  extend self

  B_UI = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/welcomer.ui")
  B_HL = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/header_left.ui")
  B_HR = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/header_right.ui")
  B_HS = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/hash_list.ui")
  B_TL = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/tools.ui")
  B_HT = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/switcher.ui")
  B_SP = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/spinner.ui")
  B_FI = Gtk::Builder.new_from_resource("/dev/geopjr/Hashbrown/ui/file_info.ui")

  WINDOW_BOX = Gtk::Box.new(Gtk::Orientation::Vertical, 0)
  HEADERBAR  = Adw::HeaderBar.new

  WELCOME_BUTTON               = Gtk::Button.cast(B_UI["welcomeBtn"])
  OPEN_FILE_BUTTON             = Gtk::Button.cast(B_HL["openFileBtn"])
  MENU_BUTTON                  = Gtk::MenuButton.cast(B_HR["menuBtn"])
  MAIN_FILE_CHOOSER_NATIVE     = Gtk::FileChooserNative.cast(B_HL["mainFileChooserNative"])
  WELCOMER_FILE_CHOOSER_NATIVE = Gtk::FileChooserNative.cast(B_UI["welcomerFileChooserNative"])
  HEADER_TITLE                 = Adw::ViewSwitcherTitle.cast(B_HT["switcher_title"])
  BOTTOM_TABS                  = Adw::ViewSwitcherBar.cast(B_HT["switcher_bar"])
  STACK                        = Adw::ViewStack.cast(B_HT["stack"])
  SPINNER                      = Gtk::Spinner.cast(B_SP["spinner"])

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

  CHECKSUM_PAGE = Adw::StatusPage.cast(B_TL["checksumStatus"])
  COMPARE_PAGE  = Adw::StatusPage.cast(B_TL["compareStatus"])

  TOOLS_BOX                        = Gtk::Box.cast(B_TL["tools"])
  TOOL_VERIFY_OVERLAY              = Gtk::Overlay.cast(B_TL["verifyOverlay"])
  TOOL_VERIFY_OVERLAY_LABEL        = Gtk::Label.cast(B_TL["verifyOverlayLabel"])
  TOOL_VERIFY_FEEDBACK             = Gtk::Image.cast(B_TL["verifyFeedback"])
  TOOL_COMPARE_BUTTON              = Gtk::Button.cast(B_TL["compareBtn"])
  TOOL_COMPARE_BUTTON_IMAGE        = Gtk::Image.cast(B_TL["compareBtnImage"])
  TOOL_COMPARE_BUTTON_LABEL        = Gtk::Label.cast(B_TL["compareBtnLabel"])
  TOOL_COMPARE_BUTTON_SPINNER      = Gtk::Spinner.cast(B_TL["spinner"])
  TOOL_COMPARE_FILE_CHOOSER_NATIVE = Gtk::FileChooserNative.cast(B_TL["compareFileChooserNative"])

  COPY_BUTTONS     = gen_hash(true)
  FILE_SET_SPINNER = Gtk::Spinner.cast(B_SP["spinner"])
  CLIPBOARD_HASH   = Hash(String, String).new
  ACTION_ROWS      = gen_hash(false)

  FILE_INFO = Adw::StatusPage.cast(B_FI["fileInfo"])
  HASH_LIST = Gtk::ListBox.cast(B_HS["hashList"])

  APP = Adw::Application.new("dev.geopjr.Hashbrown", Gio::ApplicationFlags::None)
end

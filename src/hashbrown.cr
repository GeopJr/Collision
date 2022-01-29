require "libadwaita"
require "compiled_license"

require "./modules/global_vars.cr"
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

  B_UI = Gtk::Builder.new_from_string(UI, UI.bytesize.to_i64)
  B_HL = Gtk::Builder.new_from_string(HL, HL.bytesize.to_i64)
  B_HR = Gtk::Builder.new_from_string(HR, HR.bytesize.to_i64)
  B_HS = Gtk::Builder.new_from_string(HS, HS.bytesize.to_i64)
  B_TL = Gtk::Builder.new_from_string(TL, TL.bytesize.to_i64)
  B_HT = Gtk::Builder.new_from_string(HT, HT.bytesize.to_i64)
  B_SP = Gtk::Builder.new_from_string(SP, SP.bytesize.to_i64)

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

  TOOL_VERIFY_ROW    = Adw::ActionRow.cast(B_TL["tool1Row"])
  TOOL_VERIFY_BUTTON = Gtk::Button.cast(B_TL["verifyBtn"])
  TOOL_VERIFY_INPUT  = Gtk::Entry.cast(B_TL["hashInput"])

  TOOL_COMPARE_ROW                 = Adw::ActionRow.cast(B_TL["tool2Row"])
  TOOL_COMPARE_BUTTON              = Gtk::Button.cast(B_TL["compareBtn"])
  TOOL_COMPARE_FILE_CHOOSER_NATIVE = Gtk::FileChooserNative.cast(B_TL["compareFileChooserNative"])

  COPY_BUTTONS = gen_hash(true)

  HASH_LIST = Adw::StatusPage.cast(B_HS["hashList"])

  CLIPBOARD_HASH = Hash(String, String).new

  ACTION_ROWS = gen_hash(false)

  CSS = Gtk::CssProvider.new

  APP = Adw::Application.new("dev.geopjr.Hashbrown", Gio::ApplicationFlags::None)
end

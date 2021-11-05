require "libadwaita"
require "compiled_license"

require "./modules/global_vars.cr"
require "./modules/functions/*"
require "./modules/views/*"
require "./modules/views/tools/*"

module Hashbrown
  extend self

  B_UI = Gtk::Builder.new_from_string(UI, UI.bytesize.to_i64)
  B_HL = Gtk::Builder.new_from_string(HL, HL.bytesize.to_i64)
  B_HR = Gtk::Builder.new_from_string(HR, HR.bytesize.to_i64)
  B_HS = Gtk::Builder.new_from_string(HS, HS.bytesize.to_i64)
  B_TL = Gtk::Builder.new_from_string(TL, TL.bytesize.to_i64)
  B_HT = Gtk::Builder.new_from_string(HT, HT.bytesize.to_i64)

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

  TOOL_VALIDATE_ROW    = Adw::ActionRow.cast(B_TL["tool1Row"])
  TOOL_VALIDATE_BUTTON = Gtk::Button.cast(B_TL["validateBtn"])
  TOOL_VALIDATE_INPUT  = Gtk::Entry.cast(B_TL["hashInput"])

  TOOL_COMPARE_ROW                 = Adw::ActionRow.cast(B_TL["tool2Row"])
  TOOL_COMPARE_BUTTON              = Gtk::Button.cast(B_TL["compareBtn"])
  TOOL_COMPARE_FILE_CHOOSER_NATIVE = Gtk::FileChooserNative.cast(B_TL["compareFileChooserNative"])

  COPY_BUTTONS = [
    Gtk::Button.cast(B_HS["copyBtn1"]),
    Gtk::Button.cast(B_HS["copyBtn2"]),
    Gtk::Button.cast(B_HS["copyBtn3"]),
    Gtk::Button.cast(B_HS["copyBtn4"]),
  ]

  CLIPBOARD_HASH = Hash(Gtk::Button, String).new

  TEXT_FIELDS = {
    "md5sum"    => Gtk::Entry.cast(B_HS["textField1"]),
    "sha1sum"   => Gtk::Entry.cast(B_HS["textField2"]),
    "sha256sum" => Gtk::Entry.cast(B_HS["textField3"]),
    "sha512sum" => Gtk::Entry.cast(B_HS["textField4"]),
  }

  APP = Adw::Application.new("dev.geopjr.Hashbrown", Gio::ApplicationFlags::None)
end

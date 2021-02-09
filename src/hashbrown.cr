require "gobject/gtk/autorun"
require "compiled_license"

require "./modules/functions/*"
require "./modules/views/*"
require "./modules/windows/*"

module Hashbrown
  extend self

  BUILDER = Gtk::Builder.new_from_file "#{__DIR__}/window.glade"

  COMPARE_STATUS = Gtk::Label.cast(BUILDER["compareStatus"])

  VERIFY_STATUS = Gtk::Label.cast(BUILDER["verifyStatus"])

  MAIN_FILE = Gtk::FileChooserButton.cast(BUILDER["mainFile"])

  COPY_BUTTONS = [
    Gtk::Button.cast(BUILDER["copyBtn1"]),
    Gtk::Button.cast(BUILDER["copyBtn2"]),
    Gtk::Button.cast(BUILDER["copyBtn3"]),
  ]

  CLIPBOARD_HASH = Hash(Gtk::Button, String).new

  TEXT_FIELDS = {
    "md5sum"    => Gtk::TextView.cast(BUILDER["textField1"]),
    "sha1sum"   => Gtk::TextView.cast(BUILDER["textField2"]),
    "sha256sum" => Gtk::TextView.cast(BUILDER["textField3"]),
  }
end

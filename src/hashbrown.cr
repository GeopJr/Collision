require "gobject/gtk/autorun"
require "compiled_license"
# rucksack won't be used for now
# require "rucksack"

require "./modules/functions/*"
require "./modules/views/*"
require "./modules/windows/*"

# ENV["RUCKSACK_MODE"] ||= "2"

# {% for name in `find ./src/translations -type f`.split('\n') %}
#   rucksack({{name}})
# {% end %}

module Hashbrown
  extend self

  VERSION = {{read_file("./shard.yml").split("version: ")[1].split("\n")[0]}} # Shards binary might not be in PATH, reading yml is safer

  LANGS = {{`find ./translations -type f`.split('\n').map { |x| x.gsub(/.+\/|.js$/, "") }.reject { |x| x.downcase == "hashbrown" || x == "" || x.nil? }}}

  GLADES = begin
    tmp = Hash(String, String).new
    {% for lang in `find ./translations -type f`.split('\n').map { |x| x.gsub(/.+\/|.js$/, "") }.reject { |x| x.downcase == "hashbrown" || x == "" || x.nil? } << "en" %}
    tmp[{{lang}}] = {{read_file("./src/translations/hashbrown-" + lang + ".glade")}}.gsub(/<property name=\"version\">0.0.0<\/property>/, "<property name=\"version\">#{VERSION}</property>")
  {% end %}
    tmp
  end

  LANG = begin
    current_lang = Hashbrown.current_language
    current_lang = "en" unless LANGS.includes?(current_lang)
    current_lang
  end

  # GLADE = begin
  #   tmp = IO::Memory.new
  #   rucksack("./src/translations/hashbrown#{LANG == "en" ? "" : "-" + LANG}.glade").read(tmp, false)
  #   tmp.to_s.gsub(/<property name=\"version\">0.0.0<\/property>/, "<property name=\"version\">#{VERSION}</property>")
  # end

  BUILDER = Gtk::Builder.new_from_string(GLADES[LANG], -1)

  COMPARE_STATUS = Gtk::Stack.cast(BUILDER["compareStatus"])

  VERIFY_STATUS = Gtk::Stack.cast(BUILDER["verifyStatus"])

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

# Accepts "-l <lang>" or "--lang=<lang>", parses the translation and returns it in a format easily parsable by the main app.
# This runs at compile time, so the main app doesn't require the dependencies.

require "yaml"
require "option_parser"

TRANSLATION_DIR_NAME = "translations"

lang_file = "en"
keys = [] of String
values = [] of String

OptionParser.parse do |parser|
  parser.on "-l LANG", "--lang=LANG", "The lang yaml to parse" do |lang|
    next if lang.downcase == "en"
    lang_file = lang.downcase.ends_with?(".yaml") ? lang : lang + ".yaml"
    exit if lang_file == "hashbrown.yaml" || !File.exists?(Path[TRANSLATION_DIR_NAME].join(lang_file))
  end
end

lang_file = "hashbrown.yaml" if lang_file == "en"

translation_path = Path[TRANSLATION_DIR_NAME].join(lang_file)
translation_yaml = File.open(translation_path) do |file|
  YAML.parse(file)
end

translation_yaml.as_h.each do |x, y|
  keys << x.as_s
  values << (y.as_s? ? y.as_s : x.as_s)
end

puts keys.join("\n")
puts "---"
puts values.join("\n")

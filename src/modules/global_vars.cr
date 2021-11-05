# Macro that spreads an array [[keys], [values]]
# creates a hash out of it
macro a2h(array)
    Hash.zip({{array.first}}, {{array.last}})
end

module Hashbrown
  extend self

  HASH_FUNCTIONS = ["MD5", "SHA1", "SHA256", "SHA512"]
  VERSION        = {{read_file("./shard.yml").split("version: ")[1].split("\n")[0]}} # Shards binary might not be in PATH, reading yml is safer
  THANKS         = {{run("../../extra/scripts/thank_translators").stringify}}
  TRANSLATIONS   = Hash(String, Hash(String, String)).new

  # For each file in the translations folder, create a language => {key => translation} hash entry
  {% for filename in `find ./translations -type f`.split('\n').reject { |x| x.nil? || x.size == 0 } %}
      {{lang_code = filename.gsub(/hashbrown\.yaml/, "en.yaml").gsub(/.+\/|\.yaml/, "")}}
      TRANSLATIONS[{{lang_code.downcase}}] = a2h({{run("../../extra/scripts/get_translation", "--lang=" + lang_code).stringify.split("---").map { |x| x.split("\n").reject { |x| x.nil? || x.size == 0 } }}})
  {% end %}

  CURRENT_LANGUAGE = Hashbrown.current_language
  ARTICLE          = TRANSLATIONS[CURRENT_LANGUAGE]["https://en.wikipedia.org/wiki/Comparison_of_cryptographic_hash_functions"]

  UI = Hashbrown.translate({{read_file("./src/modules/ui/welcomer.ui")}})
  HL = Hashbrown.translate({{read_file("./src/modules/ui/header_left.ui")}})
  HR = Hashbrown.translate({{read_file("./src/modules/ui/header_right.ui")}})
  HS = Hashbrown.translate({{read_file("./src/modules/ui/hash_list.ui")}})
  TL = Hashbrown.translate({{read_file("./src/modules/ui/tools.ui")}})
  HT = Hashbrown.translate({{read_file("./src/modules/ui/switcher.ui")}})
end

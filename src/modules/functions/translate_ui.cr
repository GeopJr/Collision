# Translates the ui files during runtime

# # Why not ECR?
# ## Don't want to bundle the whole ui files for each language in the binary,
# ## plus it loads them in memory

# # Why not <insert template engine>?
# ## Don't want an extra dependency

# # Why no compile them during compile time and then bundle them using rucksack?
# ## I don't know. At the moment, doing the following during runtime seems fast
# ## enough and there are not enough strings to have an impact in memory, speed
# ## or size

module Hashbrown
  extend self

  def translate(ui : String, lang_code : String? = CURRENT_LANGUAGE) : String
    ui.gsub(/HASHBROWN_\(.+\)/) { |s| TRANSLATIONS[lang_code][s[11..-2]] }
  end
end

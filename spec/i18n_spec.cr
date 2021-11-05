require "./spec_helper"
require "../src/modules/functions/current_lang.cr"
require "../src/modules/functions/translate_ui.cr"

Hashbrown::TRANSLATIONS.merge!({
  "el" => {
    "Hello World" => "Γεία σου Κόσμε",
  },
  "en" => Hash(String, String).new,
  "ru" => Hash(String, String).new,
})

describe "i18n" do
  ENV["LANGUAGE"] = "el:en_US.UTF-8"
  it "gets current language" do
    lang = Hashbrown.current_language

    lang.should eq("el")
  end
  it "translates strings" do
    original = "HASHBROWN_(Hello World)"
    translated = Hashbrown.translate(original, Hashbrown.current_language)

    translated.should eq(Hashbrown::TRANSLATIONS["el"]["Hello World"])
  end
end

require "./spec_helper"
require "../src/modules/functions/current_lang.cr"

describe "i18n" do
  ENV["LANGUAGE"] = "en_US.UTF-8"
  it "gets current language" do
    lang = Hashbrown.current_language

    lang.should eq("en")
  end
end

module Hashbrown
  extend self

  Gettext.setlocale(Gettext::LC::ALL, "")
  Gettext.bindtextdomain("dev.geopjr.Hashbrown", {{env("HASHBROWN_LOCALE_LOCATION").nil? ? "/usr/share/locale" : env("HASHBROWN_LOCALE_LOCATION")}})
  Gettext.textdomain("dev.geopjr.Hashbrown")

  HASH_FUNCTIONS = ["MD5", "SHA1", "SHA256", "SHA512"]
  VERSION        = {{read_file("./shard.yml").split("version: ")[1].split("\n")[0]}} # Shards binary might not be in PATH, reading yml is safer
  THANKS         = {{run("../../data/scripts/thank_translators").stringify}}

  ARTICLE = Gettext.gettext("https://en.wikipedia.org/wiki/Comparison_of_cryptographic_hash_functions")

  RESOURCE = Gio::Resource.new_from_data(GLib::Bytes.new({{read_file("./data/dev.geopjr.Hashbrown.gresource")}}.bytes))
  RESOURCE._register
end

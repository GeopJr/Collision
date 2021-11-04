# Prints all translators (thanks!).

TRANSLATION_DIR_NAME = "translations"

translations_dir = Dir.open(TRANSLATION_DIR_NAME)
translations = translations_dir.children.reject! { |x| x == "hashbrown.yaml" || !x.ends_with?(".yaml") }

thanks = [] of String

regex = {
  "lang"        => /## ?Language\: ?(.+)\n/,
  "translators" => /## ?(.+) \<.+\>, [0-9]{4}.?\n/,
}

translations.each do |translation|
  translation_path = Path[TRANSLATION_DIR_NAME].join(translation)
  translation_content = File.read(translation_path)
  lang = translation_content.scan(regex["lang"])[0]?.try &.[1]?
  translators = translation_content.scan(regex["translators"])
  translators.each do |t_md|
    t_name = t_md[1]?
    next if t_name.nil?
    thanks_string = "#{t_name}#{lang.nil? ? "" : " (" + lang.upcase + ")"}"
    thanks << thanks_string
  end
end

thanks.sort! { |a, b| a.split(" ")[-1] <=> b.split(" ")[-1] }

puts thanks.join("\n")

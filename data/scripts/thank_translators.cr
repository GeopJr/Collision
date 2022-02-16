# Prints all translators (thanks!).

TRANSLATION_DIR_NAME = "po"

translations_dir = Dir.open(TRANSLATION_DIR_NAME)
translations = translations_dir.children.reject! { |x| x == !x.ends_with?(".po") }

thanks = Hash(String, Array(String)).new

regex = {
  "lang"        => /\n\"Language\: ?(.+)\\n\"\n/,
  "translators" => /# ?(.+) \<.+\>, [0-9]{4}.?\n/,
}

translations.each do |translation|
  translation_path = Path[TRANSLATION_DIR_NAME].join(translation)
  next unless File.file?(translation_path)
  translation_content = File.read(translation_path)

  lang = translation_content.scan(regex["lang"])[0]?.try &.[1]?
  translators = translation_content.scan(regex["translators"])

  translators.each do |t_md|
    t_name = t_md[1]?
    next if t_name.nil?
    thanks[t_name] = [] of String unless thanks.has_key?(t_name)
    thanks[t_name] << lang.upcase unless lang.nil?
  end
end

thanks = thanks.to_a.sort! { |a, b| a.first <=> b.first }.to_h
thanks.map { |k, v| v.sort! }

thanks_block = [] of String

thanks.each do |k, v|
  thanks_block << "#{k} (#{v.join(", ")})"
end

puts thanks_block.join("\n")

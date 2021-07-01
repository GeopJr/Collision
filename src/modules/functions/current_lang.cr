module Hashbrown
  extend self

  def current_language : String
    lang = "en"
    ENV.each do |key, value|
      next unless ["LC_ALL", "LANG", "LC_MESSAGES", "LANGUAGE"].includes?(key)
      lang = value.downcase.split(/\.|_/)[0] unless value.nil? || value.size == 0
      break
    end
    return lang
  end
end

# Gets the current set language by reading the relevant env vars
# Should accept all formats (eg. el:en_US.UTF-8:ru.UTF-8)

module Hashbrown
  extend self

  def current_language : String
    lang = "en"
    # more important -> less important
    # https://www.gnu.org/software/gettext/manual/html_node/Locale-Environment-Variables.html#Locale-Environment-Variables
    ["LANGUAGE", "LC_ALL", "LC_MESSAGES", "LANG"].each do |key|
      value = ENV[key]?
      next if value.nil?
      # If multiple locales, loop through them
      # eg. en:el:es
      value.downcase.split(":").each do |x|
        # If it's in the en_US.UTF-8 format,
        # extract the "en_US" part only
        tmp = x.split(".")[0]?
        tmp = x if tmp.nil?
        # If it's available,
        # set and stop the loop
        if TRANSLATIONS.has_key?(tmp)
          lang = tmp
          break
        else
          # If it's not available,
          # extract the "en" part only
          tmp = tmp.split("_")[0]?
          # If it's available,
          # set and stop the loop
          if TRANSLATIONS.has_key?(tmp)
            lang = tmp
            break
          end
        end
      end
      break
    end
    return lang.nil? || !TRANSLATIONS.has_key?(lang) ? "en" : lang
  end
end

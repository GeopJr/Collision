# Resets the window after a main file set
# Updates the filename in the StatusPage & calls generate_hashes

module Collision::FileUtils
  extend self

  def real_path(filepath : Path) : String | Nil
    {% if !env("FLATPAK_ID").nil? || file_exists?("/.flatpak-info") %}
      return nil if filepath.parents.includes?(Path["/", "run", "user"])
    {% end %}
    filepath.dirname.to_s
  end

  # Checks if path is a File and exists.
  # If it doesn't, it will either raise an exception
  # or just log an error based on the `exception` param.
  def file?(file : Path | String, exception : Bool = false) : Bool
    return true if File.file?(file)

    msg = "\"#{file}\" does not exist or is not a File"
    if exception
      raise msg
    else
      Collision::LOGGER.debug { msg }
    end

    false
  end

  # Checks if any of the `needles` are in the `file_path` file
  def compare_content(file_path : Path | String, needles : Array(String)) : Bool
    Collision::LOGGER.debug { "Begin comparing content" }
    res = false

    File.open(file_path) do |file_io|
      file_io.each_line do |line|
        break res = true if line.split(' ').any? { |word| needles.includes?(word.downcase) }
      end
    end

    Collision::LOGGER.debug { "Finished comparing content" }
    res
  end
end

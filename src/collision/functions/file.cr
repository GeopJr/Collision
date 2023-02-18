# Resets the window after a main file set
# Updates the filename in the StatusPage & calls generate_hashes

module Collision
  class FileUtil
    def initialize(@hash_list : HashList, @file_info_page : Adw::StatusPage, @root : Adw::ViewStack)
    end

    def real_path(filepath : Path) : String | Nil
      {% if !env("FLATPAK_ID").nil? || file_exists?("/.flatpak-info") %}
        return nil if filepath.parents.includes?(Path["/", "run", "user"])
      {% end %}
      filepath.dirname.to_s
    end

    def file=(filepath : Path)
      LOGGER.debug { "File set: \"#{filepath}\"" }

      @file_info_page.title = filepath.basename.to_s
      @file_info_page.description = real_path(filepath)

      @hash_list.clear

      @root.visible_child_name = "loading"
      LOGGER.debug { "Begin generating hashes" }
      (Collision::Functions::Checksum.new).generate(filepath.to_s) do |hash_hash|
        sleep 500.milliseconds
        GLib.idle_add do
          hash_hash.each do |k, v|
            @hash_list.set_hash(k, v)
          end
          @root.visible_child_name = "main"

          false
        end
      end
    end

    # For Gio::File.
    # Should be used instead of #file=(filepath : Path)
    # unless path is a File and exists.
    def file=(file : Gio::File)
      return if (file_path = file.path).nil?

      Collision.file?(file_path)

      self.file = file_path
    end
  end

  # Checks if path is a File and exists.
  # If it doesn't, it will either raise an exception
  # or just log an error based on the `exception` param.
  def self.file?(file : Path | String, exception : Bool = true) : Bool
    return true if File.file?(file)

    msg = "\"#{file}\" does not exist or is not a File"
    if exception
      raise msg
    else
      LOGGER.debug { msg }
    end

    false
  end
end

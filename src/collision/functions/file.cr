# File related functions

module Collision
  class FileUtil
    def initialize(@hash_list : Collision::Widgets::HashList, @file_info_page : Adw::StatusPage, @root : Adw::ViewStack)
    end

    # Don't show the path if it's in flatpak and doesn't have access to it
    def real_path(filepath : Path) : String | Nil
      {% if !env("FLATPAK_ID").nil? || file_exists?("/.flatpak-info") %}
        return nil if filepath.parents.includes?(Path["/", "run", "user"])
      {% end %}
      filepath.dirname.to_s
    end

    # Sets the current file to `filepath`
    # It assumes it exists, please call
    # #file=(file : Gio::File) otherwise
    def file=(filepath : Path)
      LOGGER.debug { "File set: \"#{filepath}\"" }

      @file_info_page.title = filepath.basename.to_s
      @file_info_page.description = real_path(filepath)

      @hash_list.clear

      # Change view to the loading one
      @root.visible_child_name = "loading"
      LOGGER.debug { "Begin generating hashes" }

      (Collision::Functions::Checksum.new).generate(filepath.to_s) do |hash_hash|
        # Updating non-visible widgets
        GLib.idle_add do
          hash_hash.each do |k, v|
            @hash_list.set_hash(k, v)
          end
          @root.visible_child_name = "main"
          EMIT_QUEUE.call

          false
        end
      end
    end

    # For Gio::File.
    # Should be used instead of #file=(filepath : Path)
    # unless path is a File and exists
    def file=(file : Gio::File)
      return if (file_path = file.path).nil?

      Collision.file?(file_path)

      self.file = file_path
    end
  end

  # Checks if path is a File and exists.
  # If it doesn't, it will either raise an exception
  # or just log an error based on the `exception` param
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

# Resets the window after a main file set
# Updates the filename in the StatusPage & calls generate_hashes

module Collision
  # HASH_LIST_TITLE = Gettext.gettext("Hash")
  # TOOLS_TITLE     = Gettext.gettext("Verify")
  class FileUtil
    def initialize(@hash_list : HashList, @file_info_page : Adw::StatusPage)
    end

    def reset
      # OPEN_FILE_BUTTON.visible = true
      # HEADER_TITLE.visible = true
      # BOTTOM_TABS.visible = true

      # hash_list_page = STACK.add_titled(HASH_LIST, "hashes", HASH_LIST_TITLE)
      # hash_list_page.icon_name = "octothorp-symbolic"
      # tools_page = STACK.add_titled(TOOLS_GRID, "verify", TOOLS_TITLE)
      # tools_page.icon_name = "test-pass-symbolic"

      # clamp = Adw::Clamp.cast(FILE_INFO.child.not_nil!)
      # clamp.child = STACK

      # WINDOW_BOX.append(FILE_INFO)
      # WINDOW_BOX.append(BOTTOM_TABS)
      # WINDOW_BOX.append(SPINNER)
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

      # OPEN_FILE_BUTTON.visible = false
      # FILE_INFO.visible = false
      # BOTTOM_TABS.visible = false
      # SPINNER.visible = true
      ROOOT.visible_child_name = "loading"

      # HEADER_TITLE.view_switcher_enabled = false

      LOGGER.debug { "Begin generating hashes" }
      Collision::Checksum.generate(filepath.to_s) do |hash_hash|
        sleep 500.milliseconds
        GLib.idle_add do
          hash_hash.each do |k, v|
            @hash_list.set_hash(k, v)
          end
          ROOOT.visible_child_name = "main"

          false
        end
      end
    end

    # For Gio::File.
    # Should be used instead of Collision#file=(filepath : Path)
    # unless path is a File and exists.
    def file=(file : Gio::File)
      Collision.file?(file.path.not_nil!)

      Collision::Feedback.reset

      self.file = file.path.not_nil!
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

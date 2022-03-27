# Resets the window after a main file set
# Updates the filename in the StatusPage & calls generate_hashes

module Collision
  extend self

  HASH_LIST_TITLE = Gettext.gettext("Hash")
  TOOLS_TITLE     = Gettext.gettext("Verify")

  def reset
    OPEN_FILE_BUTTON.visible = true
    HEADER_TITLE.visible = true
    BOTTOM_TABS.visible = true

    hash_list_page = STACK.add_titled(HASH_LIST, "hashes", HASH_LIST_TITLE)
    hash_list_page.icon_name = "octothorp-symbolic"
    tools_page = STACK.add_titled(TOOLS_BOX, "verify", TOOLS_TITLE)
    tools_page.icon_name = "test-pass-symbolic"

    clamp = Adw::Clamp.cast(FILE_INFO.child.not_nil!)
    clamp.child = STACK

    WINDOW_BOX.append(FILE_INFO)
    WINDOW_BOX.append(BOTTOM_TABS)
    WINDOW_BOX.append(SPINNER)
  end

  def real_path(filepath : Path) : String | Nil
    {% if !env("FLATPAK_ID").nil? || file_exists?("/.flatpak-info") %}
      return nil if filepath.parents.includes?(Path["/", "run", "user"])
    {% end %}
    filepath.dirname.to_s
  end

  def set_file(filepath : Path, window : Adw::ApplicationWindow? = nil)
    LOGGER.debug { "File set: #{filepath.to_s}" }

    FILE_INFO.title = filepath.basename.to_s
    FILE_INFO.description = real_path(filepath)

    OPEN_FILE_BUTTON.visible = false
    FILE_INFO.visible = false
    BOTTOM_TABS.visible = false
    SPINNER.visible = true
    HEADER_TITLE.view_switcher_enabled = false

    LOGGER.debug { "Begin generating hashes" }
    Collision.generate_hashes(filepath.to_s) do
      OPEN_FILE_BUTTON.visible = true
      FILE_INFO.visible = true
      BOTTOM_TABS.visible = true
      SPINNER.visible = false
      HEADER_TITLE.view_switcher_enabled = true
      window.queue_draw if window
    end
  end
end

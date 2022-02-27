# Resets the window after a main file set
# Updates the filename in the StatusPage & calls generate_hashes

module Hashbrown
  extend self

  HASH_LIST_TITLE = Gettext.gettext("Hashes")
  TOOLS_TITLE     = Gettext.gettext("Tools")

  def reset(clear : Bool? = false)
    OPEN_FILE_BUTTON.visible = true
    HEADER_TITLE.visible = true
    BOTTOM_TABS.visible = true

    tools = Adw::Clamp.cast(B_TL["tools"])

    if clear
      STACK.remove(HASH_LIST)
      STACK.remove(tools)
    end

    hash_list_page = STACK.add_titled(HASH_LIST, "hashes", HASH_LIST_TITLE)
    hash_list_page.icon_name = "view-list-bullet-symbolic"
    tools_page = STACK.add_titled(tools, "tools", TOOLS_TITLE)
    tools_page.icon_name = "preferences-system-symbolic"

    WINDOW_BOX.append(STACK)
    WINDOW_BOX.append(BOTTOM_TABS)
    WINDOW_BOX.append(FILE_SET_SPINNER)
  end

  def set_file(filepath : Path)
    HASH_LIST.title = filepath.basename.to_s
    HASH_LIST.description = filepath.dirname.to_s

    FILE_SET_SPINNER.vexpand = true
    FILE_SET_SPINNER.visible = false
    FILE_SET_SPINNER.width_request = 32
    FILE_SET_SPINNER.height_request = 32
    FILE_SET_SPINNER.start

    OPEN_FILE_BUTTON.visible = false
    STACK.visible = false
    BOTTOM_TABS.visible = false
    FILE_SET_SPINNER.visible = true
    HEADER_TITLE.view_switcher_enabled = false

    Hashbrown.generate_hashes(filepath.to_s) do
      OPEN_FILE_BUTTON.visible = true
      STACK.visible = true
      BOTTOM_TABS.visible = true
      FILE_SET_SPINNER.visible = false
      HEADER_TITLE.view_switcher_enabled = true
    end
  end
end

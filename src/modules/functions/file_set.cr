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
  end

  def set_file(filepath : Path)
    HASH_LIST.title = filepath.basename.to_s
    HASH_LIST.description = filepath.dirname.to_s

    OPEN_FILE_BUTTON.visible = false
    WINDOW_BOX.remove(STACK)
    WINDOW_BOX.remove(BOTTOM_TABS)

    spinner = SPINNER
    spinner.vexpand = true
    spinner.width_request = 32
    spinner.height_request = 32
    spinner.start

    WINDOW_BOX.append(spinner)

    Hashbrown.generate_hashes(filepath.to_s) do
      OPEN_FILE_BUTTON.visible = true
      WINDOW_BOX.remove(spinner)
      WINDOW_BOX.append(STACK)
      WINDOW_BOX.append(BOTTOM_TABS)
    end
  end
end

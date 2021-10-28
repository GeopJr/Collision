# Resets the window after a main file set

module Hashbrown
  extend self

  HASH_LIST_TITLE = TRANSLATIONS[CURRENT_LANGUAGE]["Hashes"]
  TOOLS_TITLE     = TRANSLATIONS[CURRENT_LANGUAGE]["Tools"]

  def reset(clear : Bool? = false)
    OPEN_FILE_BUTTON.visible = true
    HEADER_TITLE.visible = true
    BOTTOM_TABS.visible = true

    hash_list = Adw::Clamp.cast(B_HS["hashList"])
    hash_list.hexpand = true
    hash_list.vexpand = true

    tools = Adw::Clamp.cast(B_TL["tools"])
    tools.hexpand = true
    tools.vexpand = true

    if clear
      STACK.remove(hash_list)
      STACK.remove(tools)
    end

    hash_list_page = STACK.add_titled(hash_list, "hashes", HASH_LIST_TITLE)
    hash_list_page.icon_name = "view-list-bullet-symbolic"
    tools_page = STACK.add_titled(tools, "tools", TOOLS_TITLE)
    # applications-utilities-symbolic
    # applications-engineering-symbolic
    # applications-system-symbolic / emblem-system-symbolic
    tools_page.icon_name = "preferences-system-symbolic"

    WINDOW_BOX.append(STACK)
    WINDOW_BOX.append(BOTTOM_TABS)
  end
end

module Collision
  extend self

  def generate_headbar
    OPEN_FILE_BUTTON.visible = false

    HEADERBAR.pack_start(OPEN_FILE_BUTTON)
    HEADERBAR.pack_end(MENU_BUTTON)
    HEADERBAR.title_widget = HEADER_TITLE
  end
end

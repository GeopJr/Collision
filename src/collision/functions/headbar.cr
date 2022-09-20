module Collision::Headbar
  extend self

  def generate
    OPEN_FILE_BUTTON.visible = false

    HEADERBAR.pack_start(OPEN_FILE_BUTTON)
    HEADERBAR.pack_end(MENU_BUTTON)
    HEADERBAR.title_widget = HEADER_TITLE
  end
end

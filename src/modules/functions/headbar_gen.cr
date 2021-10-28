module Hashbrown
  extend self

  def generate_headbar(left : Bool? = false, original_header : Adw::HeaderBar? = nil) : Adw::HeaderBar
    header = Adw::HeaderBar.new

    OPEN_FILE_BUTTON.visible = false

    header.pack_start(OPEN_FILE_BUTTON)
    header.pack_end(MENU_BUTTON)
    header.title_widget = HEADER_TITLE

    header
  end
end

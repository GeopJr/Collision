module Collision
  class Headerbar
    getter widget : Adw::HeaderBar

    def initialize(
      headerbar : Adw::HeaderBar = Adw::HeaderBar.new,
      open_file_button : Gtk::Button = OPEN_FILE_BUTTON,
      menu_button : Gtk::MenuButton = MENU_BUTTON,
      title : Adw::ViewSwitcherTitle = HEADER_TITLE
    )
      open_file_button.visible = false

      headerbar.pack_start(open_file_button)
      headerbar.pack_end(menu_button)
      headerbar.title_widget = title
      headerbar.centering_policy = Adw::CenteringPolicy::Strict

      @widget = headerbar
    end

    def title=(title : Adw::ViewSwitcherTitle)
      @widget.title_widget = title
    end
  end
end

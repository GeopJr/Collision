module Collision
  class Headerbar
    getter widget : Adw::HeaderBar = Adw::HeaderBar.new
    getter open_file_button : Gtk::Button
    getter menu_button : Gtk::MenuButton

    def initialize(
      file_util : FileUtil,
      title : Adw::ViewSwitcherTitle
    )
      @widget = Adw::HeaderBar.new

      @open_file_button = Gtk::Button.new(
        visible: false,
        child: Adw::ButtonContent.new(
          icon_name: "document-open-symbolic",
          use_underline: true,
          label: Gettext.gettext("_Open"),
          tooltip_text: Gettext.gettext("Open..."),
          css_classes: {"flat"}
        )
      )

      @menu_button = Gtk::MenuButton.cast(B_HR["menuBtn"])

      open_file_file_chooser_native = Gtk::FileChooserNative.new(
        title: Gettext.gettext("Choose a File"),
        modal: true
      )
      open_file_file_chooser_native.transient_for = APP.active_window

      open_file_file_chooser_native.response_signal.connect do |response|
        next unless response == -3

        file_util.file = open_file_file_chooser_native.file.not_nil!
      rescue ex
        LOGGER.debug { ex }
      end

      @open_file_button.clicked_signal.connect do
        open_file_file_chooser_native.show
      end

      @widget.pack_start(@open_file_button)
      @widget.pack_end(@menu_button)
      @widget.title_widget = title
    end

    def title=(title : Adw::ViewSwitcherTitle)
      @widget.title_widget = title
    end
  end
end

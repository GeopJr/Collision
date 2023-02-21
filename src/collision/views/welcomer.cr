# The welcomer.

module Collision::Views
  class Welcomer
    getter widget : Adw::StatusPage
    @passed : Bool = false

    def initialize(@file_util : Collision::FileUtil, open_file_file_chooser_native : Gtk::FileChooserNative)
      welcome_button = Gtk::Button.new(
        label: Gettext.gettext("_Open a File"),
        halign: Gtk::Align::Center,
        use_underline: true,
        css_classes: {"suggested-action", "pill"},
      )

      @widget = Adw::StatusPage.new(
        vexpand: true,
        icon_name: "dev.geopjr.Collision",
        title: Gettext.gettext("Collision"),
        description: Gettext.gettext("Check hashes for your files"),
        child: welcome_button,
        css_classes: {"icon-dropshadow"}
      )

      welcome_button.clicked_signal.connect do
        open_file_file_chooser_native.show
      end
    end
  end
end

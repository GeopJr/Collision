# The welcomer.

module Collision::Views
  class Welcomer
    getter widget : Adw::StatusPage
    @passed : Bool = false

    def initialize(@file_util : Collision::FileUtil)
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

      welcome_file_chooser_native = Gtk::FileChooserNative.new(
        title: Gettext.gettext("Choose a File"),
        modal: true
      )
      welcome_file_chooser_native.transient_for = APP.active_window

      welcome_button.clicked_signal.connect do
        welcome_file_chooser_native.show
      end

      welcome_file_chooser_native.response_signal.connect do |response|
        next unless response == -3 && !(gio_file = welcome_file_chooser_native.file).nil?

        self.file = gio_file
      rescue ex
        LOGGER.debug { ex }
      end
    end

    def passed? : Bool
      @passed
    end

    def file=(file : Gio::File)
      return if (file_path = file.path).nil?
      Collision.file?(file_path)

      @file_util.file = file_path
      @passed = true

      LOGGER.debug { "Passed welcomer" }
    end
  end
end

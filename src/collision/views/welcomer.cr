module Collision
  class Welcomer
    getter widget : Adw::StatusPage
    @passed : Bool = false

    def initialize(@file_util : Collision::FileUtil)
      welcome_button = Gtk::Button.new_with_mnemonic(Gettext.gettext("_Open a File"))
      welcome_button.halign = Gtk::Align::Center
      welcome_button.add_css_class("suggested-action")
      welcome_button.add_css_class("pill")

      @widget = Adw::StatusPage.new(
        vexpand: true,
        icon_name: "dev.geopjr.Collision",
        title: Gettext.gettext("Collision"),
        description: Gettext.gettext("Check hashes for your files"),
        child: welcome_button
      )
      @widget.add_css_class("icon-dropshadow")

      welcome_file_chooser_native = Gtk::FileChooserNative.new(
        title: Gettext.gettext("Choose a File"),
        modal: true
      )
      welcome_file_chooser_native.transient_for = APP.active_window

      welcome_button.clicked_signal.connect do
        welcome_file_chooser_native.show
      end

      welcome_file_chooser_native.response_signal.connect do |response|
        next unless response == -3

        self.file = welcome_file_chooser_native.file.not_nil!
      rescue ex
        LOGGER.debug { ex }
      end
    end

    def passed? : Bool
      @passed
    end

    def file=(file : Gio::File)
      Collision.file?(file.path.not_nil!)

      # WINDOW_BOX.remove(@widget)
      # Collision.reset

      @file_util.file = file.path.not_nil!
      @passed = true

      LOGGER.debug { "Passed welcomer" }
    end
  end
end

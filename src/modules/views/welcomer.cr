module Collision
  module Welcomer
    extend self

    def init(window : Adw::ApplicationWindow)
      WELCOME_BUTTON.clicked_signal.connect do
        WELCOMER_FILE_CHOOSER_NATIVE.show
      end

      WELCOMER_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
        next unless response == -3
        WINDOW_BOX.remove(Gtk::Widget.cast(B_UI["welcomer"]))
        Collision.reset

        Collision.set_file(WELCOMER_FILE_CHOOSER_NATIVE.file.not_nil!.path.not_nil!, window)
        LOGGER.debug { "Passed welcomer" }
      end
    end
  end
end

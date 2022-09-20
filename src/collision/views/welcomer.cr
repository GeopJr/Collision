module Collision
  module Welcomer
    extend self
    @@passed = false

    def init
      WELCOME_BUTTON.clicked_signal.connect do
        WELCOMER_FILE_CHOOSER_NATIVE.show
      end

      WELCOMER_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
        next unless response == -3

        Collision::Welcomer.file = WELCOMER_FILE_CHOOSER_NATIVE.file.not_nil!
      rescue ex
        LOGGER.debug { ex }
      end
    end

    def file=(file : Gio::File)
      Collision.file?(file.path.not_nil!)

      WINDOW_BOX.remove(Gtk::Widget.cast(B_UI["welcomer"]))
      Collision.reset

      Collision.file = file.path.not_nil!
      @@passed = true

      LOGGER.debug { "Passed welcomer" }
    end

    def passed? : Bool
      @@passed
    end
  end
end

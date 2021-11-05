module Hashbrown
  module Welcomer
    extend self

    def init
      WELCOME_BUTTON.clicked_signal.connect do
        WELCOMER_FILE_CHOOSER_NATIVE.show
      end

      WELCOMER_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
        next unless response == -3
        WINDOW_BOX.remove(Gtk::Widget.cast(B_UI["welcomer"]))
        Hashbrown.reset
        Hashbrown.generate_hashes(WELCOMER_FILE_CHOOSER_NATIVE.file.path.not_nil!.to_s)
      end
    end
  end
end

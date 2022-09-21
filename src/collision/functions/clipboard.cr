module Collision
  class Clipboard
    getter clipboard : Gdk::Clipboard

    def initialize(window : Adw::ApplicationWindow, copy_buttons : Hash(String, Gtk::Button))
      @clipboard = window.clipboard
      @copy_buttons = copy_buttons

      setup_copy_buttons
    end

    private def setup_copy_buttons
      @copy_buttons.each do |hash_type, btn|
        # Soft lock is being used to avoid
        # spamming the copy buttons until
        # the button feedback resets.
        soft_locked = false

        btn.clicked_signal.connect do
          LOGGER.debug { "Copied #{hash_type} hash" }

          hash = CLIPBOARD_HASH[hash_type]
          success = true
          begin
            @clipboard.set(hash)
          rescue
            success = false
          end

          next if soft_locked
          soft_locked = true

          btn.icon_name = Collision::Feedback.icon(success)
          feedback_class = success ? "success" : "error"
          btn.add_css_class(feedback_class)
          Non::Blocking.spawn do
            sleep 1.1.seconds # 1 feels fast, 1.5 feels slow
            btn.icon_name = "edit-copy-symbolic"
            btn.remove_css_class(feedback_class)
            soft_locked = false

            LOGGER.debug { "Copy button feedback reset" }
          end
        end
      end
    end
  end
end

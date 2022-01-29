module Hashbrown
  module Compare
    extend self

    def init
      TOOL_COMPARE_BUTTON.clicked_signal.connect do
        TOOL_COMPARE_FILE_CHOOSER_NATIVE.show
      end

      TOOL_COMPARE_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
        next unless response == -3

        # Adding and then removing a prefix introduces extra padding (GtkBox), disabled for now.
        # Tracked: https://gitlab.gnome.org/GNOME/libadwaita/-/issues/395
        #
        # TOOL_COMPARE_ROW.icon_name = nil
        # spinner = SPINNER
        # spinner.start
        # TOOL_COMPARE_ROW.add_prefix(spinner)
        TOOL_COMPARE_ROW.icon_name = "process-working-symbolic"

        Hashbrown.handle_spawning do
          compareFileSHA256 = Hashbrown.calculate_hash("sha256", TOOL_COMPARE_FILE_CHOOSER_NATIVE.file.path.to_s)
          result = CLIPBOARD_HASH["SHA256"] == compareFileSHA256
          # TOOL_COMPARE_ROW.remove(spinner)
          TOOL_COMPARE_ROW.icon_name = Hashbrown.icon(result)
        end
      end
    end
  end
end

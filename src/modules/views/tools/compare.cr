module Hashbrown
  module Compare
    extend self

    def init
      TOOL_COMPARE_BUTTON.clicked_signal.connect do
        TOOL_COMPARE_FILE_CHOOSER_NATIVE.show
      end

      TOOL_COMPARE_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
        next unless response == -3

        channel = Channel(Hash(String, String)).new
        spawn(Hashbrown.calculate_hash("sha256", TOOL_COMPARE_FILE_CHOOSER_NATIVE.file.path.to_s, channel))

        compareFileSHA256 = channel.receive["SHA256"]
        result = CLIPBOARD_HASH["SHA256"] == compareFileSHA256

        TOOL_COMPARE_ROW.icon_name = Hashbrown.icon(result)
      end
    end
  end
end

module Hashbrown
  module Compare
    extend self

    def init
      TOOL_COMPARE_BUTTON.clicked_signal.connect do
        TOOL_COMPARE_FILE_CHOOSER_NATIVE.show
      end

      TOOL_COMPARE_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
        next unless response == -3
        compareFileMD5 = Hashbrown.run_cmd("md5sum", [TOOL_COMPARE_FILE_CHOOSER_NATIVE.file.path.to_s]).split(" ")[0]
        result = CLIPBOARD_HASH[COPY_BUTTONS[0]] == compareFileMD5
        TOOL_COMPARE_ROW.icon_name = Hashbrown.icon(result)
      end
    end
  end
end

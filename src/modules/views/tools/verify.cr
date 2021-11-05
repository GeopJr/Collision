module Hashbrown
  module Verify
    extend self

    def init
      TOOL_VERIFY_BUTTON.clicked_signal.connect do
        input = TOOL_VERIFY_INPUT.buffer.text
        result = CLIPBOARD_HASH.values.includes?(input)
        TOOL_VERIFY_ROW.icon_name = Hashbrown.icon(result)
      end
    end
  end
end

module Hashbrown
  module Validate
    extend self

    def init
      TOOL_VALIDATE_BUTTON.clicked_signal.connect do
        input = TOOL_VALIDATE_INPUT.buffer.text
        result = CLIPBOARD_HASH.values.includes?(input)
        TOOL_VALIDATE_ROW.icon_name = Hashbrown.icon(result)
      end
    end
  end
end

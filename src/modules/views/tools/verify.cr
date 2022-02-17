module Hashbrown
  module Verify
    extend self

    def handle_input_change(text : String)
      result = CLIPBOARD_HASH.values.includes?(text)
      TOOL_VERIFY_ROW.icon_name = Hashbrown.icon(result)
    end

    def init
      TOOL_VERIFY_INPUT.notify_signal["text"].connect do
        handle_input_change(TOOL_VERIFY_INPUT.text)
      end
    end
  end
end

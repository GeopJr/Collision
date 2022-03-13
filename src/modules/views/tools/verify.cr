module Collision
  module Verify
    extend self

    def handle_input_change(text : String)
      result = CLIPBOARD_HASH.values.includes?(text)
      if text.size == 0
        TOOL_VERIFY_OVERLAY_LABEL.visible = true
        TOOL_VERIFY_FEEDBACK.visible = false
        TOOL_VERIFY_INPUT.remove_css_class("success")
        TOOL_VERIFY_INPUT.remove_css_class("error")
        return
      end
      TOOL_VERIFY_OVERLAY_LABEL.visible = false
      TOOL_VERIFY_FEEDBACK.visible = true

      TOOL_VERIFY_INPUT.add_css_class(result ? "success" : "error")
      TOOL_VERIFY_INPUT.remove_css_class(!result ? "success" : "error")

      TOOL_VERIFY_FEEDBACK.icon_name = Collision.icon(result)
      TOOL_VERIFY_FEEDBACK.add_css_class(result ? "success" : "error")
      TOOL_VERIFY_FEEDBACK.remove_css_class(!result ? "success" : "error")
    end

    def init
      TOOL_VERIFY_INPUT.buffer.notify_signal["text"].connect do
        LOGGER.debug { "Verify tool notify event" }

        handle_input_change(TOOL_VERIFY_INPUT.buffer.text)
      end
    end
  end
end

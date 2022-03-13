# Returns the correct symbolic icon for feedback based on whether or not the task was successful

module Collision
  extend self

  DEFAULT_FEEDBACK_ICON = "dialog-password-symbolic"

  def reset_feedback
    TOOL_VERIFY_INPUT.buffer.text = ""
    TOOL_VERIFY_FEEDBACK.visible = false

    TOOL_COMPARE_BUTTON_LABEL.label = Gettext.gettext("Choose File...")
    TOOL_COMPARE_BUTTON.remove_css_class("success")
    TOOL_COMPARE_BUTTON.remove_css_class("error")
    TOOL_COMPARE_BUTTON_IMAGE.icon_name = "paper-symbolic"

    LOGGER.debug { "Feedback reset" }
  end

  def icon(success : Bool? = false)
    success ? "test-pass-symbolic" : "cross-large-symbolic"
  end
end

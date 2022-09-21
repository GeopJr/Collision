# Returns the correct symbolic icon for feedback based on whether or not the task was successful

module Collision::Feedback
  extend self

  DEFAULT_FEEDBACK_ICON = "dialog-password-symbolic"
  CLASSES               = {"success", "error"}

  def reset
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

  def class(success : Bool? = false) : NamedTuple(add: String, remove: String)
    result = success ? 0 : 1

    # If result == 0 => add: CLASSES[0], remove: CLASSES[-1]
    # If result == 1 => add: CLASSES[1], remove: CLASSES[0]
    {add: CLASSES[result], remove: CLASSES[result - 1]}
  end
end

# Returns the correct symbolic icon for feedback based on whether or not the task was successful

module Hashbrown
  extend self

  DEFAULT_FEEDBACK_ICON = "dialog-password-symbolic"

  def reset_feedback
    TOOL_COMPARE_ROW.icon_name = DEFAULT_FEEDBACK_ICON
    TOOL_VALIDATE_ROW.icon_name = DEFAULT_FEEDBACK_ICON
  end

  def icon(success : Bool? = false)
    success ? "emblem-ok-symbolic" : "window-close-symbolic"
  end
end

# Returns the correct symbolic icon or class name for feedback based on whether the task was successful

module Collision::Feedback
  extend self

  CLASSES = {"success", "error"}

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

# Returns the correct symbolic icon for feedback based on whether or not the task was successful

module Hashbrown
  extend self

  def icon(success : Bool? = false)
    success ? "emblem-ok-symbolic" : "window-close-symbolic"
  end
end

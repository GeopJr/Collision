# DnD related functions

module Collision::DragNDrop
  extend self

  def dnd_enter(x, y)
    LOGGER.debug { "DnD Entered" }

    Gdk::DragAction::Copy
  end

  def dnd_leave
    LOGGER.debug { "DnD Left" }
  end

  def dnd_drop(value, x, y)
    LOGGER.debug { "DnD Dropped" }

    begin
      (Collision::Welcomer.passed? ? Collision : Collision::Welcomer).file = Gio::File.new_for_uri(value.as_s.gsub(/\r|\n/, ""))

      true
    rescue ex
      LOGGER.debug { ex }

      false
    end
  end
end

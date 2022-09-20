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
      filepath = value.as_s.split(/\r|\n/).reject { |x| !x.downcase.starts_with?("file://") }
      raise "No files starting with 'file://' given, instead got: #{value.as_s}" unless filepath.size > 0

      file = Gio::File.new_for_uri(filepath[0])
      (Collision::Welcomer.passed? ? Collision : Collision::Welcomer).file = file

      true
    rescue ex
      LOGGER.debug { ex }

      false
    end
  end

  def connect_dnd_signals(dnd : Gtk::DropTarget) : Gtk::DropTarget
    dnd.drop_signal.connect(->Collision::DragNDrop.dnd_drop(GObject::Value, Float64, Float64))
    dnd.enter_signal.connect(->Collision::DragNDrop.dnd_enter(Float64, Float64))
    dnd.leave_signal.connect(->Collision::DragNDrop.dnd_leave)

    dnd
  end

  def controller : Gtk::DropTarget
    dnd = Gtk::DropTarget.new(String.g_type, Gdk::DragAction::Copy)
    connect_dnd_signals(dnd)
  end
end

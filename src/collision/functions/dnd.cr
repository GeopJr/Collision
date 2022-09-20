# DnD related functions

module Collision
  class DragNDrop
    alias DropClasses = Collision | Collision::Welcomer | Collision::Compare

    getter parent : DropClasses
    getter controller : Gtk::DropTarget = Gtk::DropTarget.new(String.g_type, Gdk::DragAction::Copy)

    def initialize(parent : DropClasses)
      @parent = parent

      connect_dnd_signals
    end

    private def dnd_enter(x, y)
      LOGGER.debug { "DnD Entered #{@parent}" }

      Gdk::DragAction::Copy
    end

    private def dnd_leave
      LOGGER.debug { "DnD Left #{@parent}" }
    end

    private def dnd_drop(value, x, y)
      LOGGER.debug { "DnD Dropped #{@parent}" }

      begin
        filepath = value.as_s.split(/\r|\n/).reject { |x| !x.downcase.starts_with?("file://") }
        raise "No files starting with 'file://' given, instead got: #{value.as_s}" unless filepath.size > 0

        file = Gio::File.new_for_uri(filepath[0])
        @parent.file = file

        true
      rescue ex
        LOGGER.debug { ex }

        false
      end
    end

    private def connect_dnd_signals
      @controller.drop_signal.connect(->dnd_drop(GObject::Value, Float64, Float64))
      @controller.enter_signal.connect(->dnd_enter(Float64, Float64))
      @controller.leave_signal.connect(->dnd_leave)
    end
  end
end

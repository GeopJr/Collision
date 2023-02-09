# DnD related functions

module Collision
  class DragNDrop
    alias DropClasses = Collision | Collision::Welcomer | Collision::Compare

    getter parent : DropClasses
    getter controller : Gtk::DropTarget = Gtk::DropTarget.new(Gdk::FileList.g_type, Gdk::DragAction::Copy)

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
        object_ptr = LibGObject.g_value_get_boxed(value.to_unsafe)
        files = Gdk::FileList.new(object_ptr, GICrystal::Transfer::Full).files
        file = nil

        files.each do |x|
          break file = x if x.uri.downcase.starts_with?("file://")
        end
        raise "No files starting with 'file://' given" if file.nil?

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

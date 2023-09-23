# DnD related functions

module Collision
  class DragNDrop
    @on_dropped : Proc(Gio::File, Nil)
    getter controller : Gtk::DropTarget = Gtk::DropTarget.new(Gdk::FileList.g_type, Gdk::DragAction::Copy)

    def initialize(@on_dropped)
      connect_dnd_signals
    end

    private def dnd_enter(x, y)
      LOGGER.debug { "DnD Entered" }

      Gdk::DragAction::Copy
    end

    private def dnd_leave
      LOGGER.debug { "DnD Left" }
    end

    private def dnd_drop(value, x, y)
      LOGGER.debug { "DnD Dropped" }

      begin
        object_ptr = LibGObject.g_value_get_boxed(value.to_unsafe)
        files = Gdk::FileList.new(object_ptr, GICrystal::Transfer::Full).files
        file = nil

        files.each do |x|
          break file = x if x.uri.downcase.starts_with?("file://")
        end
        raise "No files starting with 'file://' given" if file.nil?

        @on_dropped.call(file)

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

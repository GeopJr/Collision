module Collision::Widgets
  @[Gtk::UiTemplate(
    resource: "/dev/geopjr/Collision/ui/hash_row.ui",
    children: {
      "copy_btn",
    }
  )]
  class HashRow < Adw::ActionRow
    include Gtk::WidgetTemplate
    signal clicked(hash_type : String)
    property copy_btn_locked : Bool = false
    @copy_btn : Gtk::Button
    @hash_type : String = ""

    def initialize
      super()

      @copy_btn = Gtk::Button.cast(template_child("copy_btn"))
      @copy_btn.clicked_signal.connect(->copy_btn_clicked_cb)
    end

    def initialize(hash_name : String, @hash_type : String)
      initialize

      self.title = hash_name
    end

    def copy_btn_clicked_cb
      return if @copy_btn_locked
      @copy_btn_locked = true
      Collision::LOGGER.debug { "Copied #{title} hash" }

      clicked_signal.emit(@hash_type)
      success = true

      @copy_btn.icon_name = Collision::Feedback.icon(success)
      feedback_class = success ? "success" : "error"
      @copy_btn.add_css_class(feedback_class)
      ::spawn do
        sleep 1.1.seconds # 1 feels fast, 1.5 feels slow
        GLib.idle_add do
          @copy_btn.icon_name = "edit-copy-symbolic"
          @copy_btn.remove_css_class(feedback_class)
          @copy_btn_locked = false
          false
        end

        Collision::LOGGER.debug { "Copy button feedback reset" }
      end
    end
  end
end

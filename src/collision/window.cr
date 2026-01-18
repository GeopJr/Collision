require "./functions/*"
require "./widgets/*"

module Collision
  @[Gtk::UiTemplate(
    resource: "/dev/geopjr/Collision/ui/application.ui",
    children: {
      "welcomeBtn",
      "mainStack",
      "fileInfo",
      "headerbarViewSwitcher",
      "openFileBtn",
      "compareBtn",
      "verifyOverlayLabel",
      "verifyTextView",
      "verifyFeedback",
      "compareBtnImage",
      "compareBtnLabel",
      "compareBtnStack",
      "switcher_bar",
      "hash_row_container",
      "progressbar",
      "mainDnd",
      "compareDnd",
      "dropOverlayRevealer",
    }
  )]
  class Window < Adw::ApplicationWindow
    include Gtk::WidgetTemplate

    HOST_PATH_ATTR = "xattr::document-portal.host-path"

    @hash_rows = Hash(Symbol, Widgets::HashRow).new
    @headerbarViewSwitcher : Adw::ViewSwitcher
    @welcomeBtn : Gtk::Button
    @compareBtn : Gtk::Button
    @compareBtnImage : Gtk::Image
    @compareBtnLabel : Gtk::Label
    @compareBtnStack : Gtk::Stack
    @openFileBtn : Gtk::Button
    @mainStack : Gtk::Stack
    @fileInfo : Adw::StatusPage
    @switcher_bar : Adw::ViewSwitcherBar
    @progressbar : Gtk::ProgressBar
    @mainDnd : Gtk::DropTarget
    @compareDnd : Gtk::DropTarget
    @dropOverlayRevealer : Gtk::Revealer

    @verifyOverlayLabel : Gtk::Label
    @verifyTextView : Gtk::TextView
    @verifyFeedback : Gtk::Image

    @hash_results = Hash(Symbol, String).new
    @file_path_queued : Path? = nil

    property working : Bool = false

    def continue_queue
      return if @file_path_queued.nil?
      self.file = @file_path_queued.not_nil!
    end

    def file=(filepath : Path)
      Collision::LOGGER.debug { "File set: \"#{filepath}\"" }

      if Collision.atomic > 0
        @file_path_queued = filepath
        return
      end

      @file_path_queued = nil
      Collision.atomic_increase
      @fileInfo.title = filepath.basename.to_s

      begin
        self.working = true
        Collision::LOGGER.debug { "Begin generating hashes" }
        Collision::Checksum.new.generate(filepath.to_s, @progressbar) do |res|
          if !self.visible
            flow_queue
            next
          end

          GLib.idle_add do
            res.each do |hash_type, hash_value|
              @hash_results[hash_type] = hash_value
              @hash_rows[hash_type].subtitle = hash_value.size < 8 ? hash_value : Collision.split_by_4(hash_value)
            end

            @mainStack.visible_child_name = "results"
            @headerbarViewSwitcher.visible = true
            @openFileBtn.visible = true
            @switcher_bar.visible = true
            flow_queue
            false
          end
        end
      rescue ex
        flow_queue
        raise ex
      end
    end

    # Force inline queue recovery
    macro flow_queue
      self.working = false
      Collision.atomic_decrease
      self.application.not_nil!.windows.each do |window|
        Window.cast(window).continue_queue
      end

      self.destroy unless self.visible
    end

    # For Gio::File.
    # Should be used instead of Collision#file=(filepath : Path)
    # unless path is a File and exists.
    def file=(file : Gio::File)
      filepath = file.path.not_nil!
      return unless Collision::FileUtils.file?(filepath)
      self.file = filepath

      {% if !env("FLATPAK_ID").nil? || file_exists?("/.flatpak-info") %}
        begin
          file.query_info_async(HOST_PATH_ATTR, Gio::FileQueryInfoFlags::None, 0, nil) do |obj, result|
            info = obj.as(Gio::File).query_info_finish(result)
            real_path = info.attribute_string(HOST_PATH_ATTR)
            @fileInfo.description = real_path.nil? ? Collision::FileUtils.real_path(filepath) : Path[real_path].parent.to_s
          end
        rescue
          @fileInfo.description = Collision::FileUtils.real_path(filepath)
        end
      {% else %}
        @fileInfo.description = Collision::FileUtils.real_path(filepath)
      {% end %}
    end

    def on_open_btn_clicked
      Gtk::FileDialog.new(
        title: Gettext.gettext("Choose a File"),
        modal: true
      ).open_multiple(self, nil) do |obj, result|
        next if (files = obj.as(Gtk::FileDialog).open_multiple_finish(result)).nil?

        gio_files = [] of Gio::File
        files.n_items.times do |i|
          gio_files << Gio::File.cast(files.item(i).not_nil!)
        end

        loading
        self.file = gio_files.shift
        open_files(Adw::Application.cast(self.application.not_nil!), gio_files) unless gio_files.empty? || self.application.nil?
      rescue ex
        Collision::LOGGER.debug { ex }
      end
    end

    def on_drop(file : Gio::File)
      loading
      self.file = file
    end

    def loading
      @progressbar.text = Gettext.gettext("Pending")
      @progressbar.fraction = 0.0
      @mainStack.visible_child_name = "spinner"
      @headerbarViewSwitcher.visible = false
      @openFileBtn.visible = false
      @switcher_bar.visible = false
      reset_feedback
    end

    def reset_feedback
      @verifyTextView.buffer.text = ""
      @compareBtnStack.visible_child_name = "image"
      @compareBtnLabel.label = Gettext.gettext("Choose File…")
      @compareBtn.remove_css_class("success")
      @compareBtn.remove_css_class("error")
      @compareBtnImage.icon_name = "paper-symbolic"
      @compareBtnImage.tooltip_text = ""
    end

    def handle_input_change(text : String)
      result = @hash_results.values.includes?(text.downcase.gsub(' ', ""))
      if text.size == 0
        @verifyOverlayLabel.visible = true
        @verifyFeedback.visible = false
        @verifyTextView.remove_css_class("success")
        @verifyTextView.remove_css_class("error")
        @verifyTextView.tooltip_text = Gettext.gettext("Insert a MD5/SHA-1/SHA-256/SHA-512/Blake3/CRC32/Adler32 Hash")
        return
      end

      @verifyOverlayLabel.visible = false
      @verifyFeedback.visible = true

      classes = Collision::Feedback.class(result)

      @verifyTextView.add_css_class(classes[:add])
      @verifyTextView.remove_css_class(classes[:remove])

      @verifyFeedback.icon_name = Collision::Feedback.icon(result)
      @verifyFeedback.add_css_class(classes[:add])
      @verifyFeedback.remove_css_class(classes[:remove])

      feedback_result = Collision::Feedback.title(result)
      @verifyTextView.tooltip_text = feedback_result
      {% if compare_versions("#{Gtk::MAJOR_VERSION}.#{Gtk::MINOR_VERSION}.#{Gtk::MICRO_VERSION}", "4.14.0") >= 0 %}
        @verifyTextView.announce(feedback_result, Gtk::AccessibleAnnouncementPriority::High)
      {% end %}
    end

    # We want to only check the file contents
    # IF the file is smaller than the size below.
    # We want to avoid loading a huge file in
    # memory but also avoid false-positives.
    MAX_COMPARE_READ_SIZE = 10000 # in bytes

    def comparefile=(file : Gio::File)
      Collision::LOGGER.debug { "Begin comparing tool" }
      file_path = file.path.not_nil!
      return unless Collision::FileUtils.file?(file_path)

      @compareBtnStack.visible_child_name = "spinner"
      @compareBtn.remove_css_class("success")
      @compareBtn.remove_css_class("error")

      @compareBtnLabel.label = file_path.basename.to_s
      @compareBtnLabel.tooltip_text = file_path.basename.to_s
      (Fiber::ExecutionContext::Concurrent.new("compare-tool")).spawn do
        compareFileSHA256 = Collision::Checksum.new.calculate(:sha256, file.path.to_s)
        result = @hash_results[:sha256] == compareFileSHA256
        result = Collision::FileUtils.compare_content(file_path, @hash_results.values) if !result && File.size(file_path) < MAX_COMPARE_READ_SIZE
        classes = Collision::Feedback.class(result)
        title = Collision::Feedback.title(result)

        sleep 500.milliseconds

        GLib.idle_add do
          @compareBtnStack.visible_child_name = "image"

          @compareBtnImage.icon_name = Collision::Feedback.icon(result)
          @compareBtn.add_css_class(classes[:add])
          @compareBtn.remove_css_class(classes[:remove])
          @compareBtnImage.tooltip_text = title
          {% if compare_versions("#{Gtk::MAJOR_VERSION}.#{Gtk::MINOR_VERSION}.#{Gtk::MICRO_VERSION}", "4.14.0") >= 0 %}
            @compareBtn.announce(title, Gtk::AccessibleAnnouncementPriority::High)
          {% end %}

          false
        end

        Collision::LOGGER.debug { "Finished comparing tool" }
      end
    end

    def copy_btn_cb(hash_type : String)
      {% begin %}
        case hash_type
          {% for hash in Collision::HASH_FUNCTIONS.keys %}
            when {{hash.stringify}}
              self.clipboard.set(@hash_results[:{{hash}}])
          {% end %}
        end
      {% end %}
    end

    macro setup_hashrows
      {% for hash, digest in Collision::HASH_FUNCTIONS %}
        hashrow = Collision::Widgets::HashRow.new({{digest}}, {{hash.stringify}})
        @hash_row_container.append (hashrow)
        hashrow.clicked_signal.connect do |hash_type|
          copy_btn_cb(hash_type)
        end
        @hash_rows[:{{hash}}] = hashrow
      {% end %}
    end

    def initialize
      super()

      file_action = Gio::SimpleAction.new("open-file", nil)
      file_action.activate_signal.connect do
        on_open_btn_clicked
      end
      add_action(file_action)

      @hash_row_container = Gtk::ListBox.cast(template_child("hash_row_container"))
      setup_hashrows

      @verifyOverlayLabel = Gtk::Label.cast(template_child("verifyOverlayLabel"))
      @verifyTextView = Gtk::TextView.cast(template_child("verifyTextView"))
      @verifyFeedback = Gtk::Image.cast(template_child("verifyFeedback"))

      @mainStack = Gtk::Stack.cast(template_child("mainStack"))
      @headerbarViewSwitcher = Adw::ViewSwitcher.cast(template_child("headerbarViewSwitcher"))
      @switcher_bar = Adw::ViewSwitcherBar.cast(template_child("switcher_bar"))
      @mainDnd = Gtk::DropTarget.cast(template_child("mainDnd"))
      @compareDnd = Gtk::DropTarget.cast(template_child("compareDnd"))
      @dropOverlayRevealer = Gtk::Revealer.cast(template_child("dropOverlayRevealer"))

      @welcomeBtn = Gtk::Button.cast(template_child("welcomeBtn"))
      @fileInfo = Adw::StatusPage.cast(template_child("fileInfo"))
      @openFileBtn = Gtk::Button.cast(template_child("openFileBtn"))

      @compareBtn = Gtk::Button.cast(template_child("compareBtn"))
      @compareBtnImage = Gtk::Image.cast(template_child("compareBtnImage"))
      @compareBtnLabel = Gtk::Label.cast(template_child("compareBtnLabel"))
      @compareBtnStack = Gtk::Stack.cast(template_child("compareBtnStack"))
      @progressbar = Gtk::ProgressBar.cast(template_child("progressbar"))

      @verifyTextView.buffer.notify_signal["text"].connect do
        Collision::LOGGER.debug { "Verify tool notify event" }

        handle_input_change(@verifyTextView.buffer.text)
      end

      @welcomeBtn.clicked_signal.connect do
        on_open_btn_clicked()
      end
      @openFileBtn.clicked_signal.connect do
        on_open_btn_clicked()
      end

      @mainDnd.enter_signal.connect do
        @dropOverlayRevealer.reveal_child = true unless @mainStack.visible_child_name == "spinner"
        Gdk::DragAction::Copy
      end

      @mainDnd.leave_signal.connect do
        @dropOverlayRevealer.reveal_child = false
      end

      @mainDnd.drop_signal.connect do |value|
        next false if @mainStack.visible_child_name == "spinner"

        if LibGObject.g_type_check_value_holds(value, Gdk::FileList.g_type)
          files = Gdk::FileList.new(LibGObject.g_value_get_boxed(value), GICrystal::Transfer::None).files
          file = nil

          files.each do |x|
            break file = x if x.uri.downcase.starts_with?("file://")
          end

          if file.nil?
            Collision::LOGGER.error { "No files starting with 'file://' given" }
            next false
          end

          on_drop(file)
          next true
        end

        false
      end

      @compareDnd.enter_signal.connect do
        @dropOverlayRevealer.reveal_child = false
        Gdk::DragAction::Copy
      end

      @compareDnd.leave_signal.connect do
        @dropOverlayRevealer.reveal_child = true
      end

      @compareDnd.drop_signal.connect do |value|
        if LibGObject.g_type_check_value_holds(value, Gdk::FileList.g_type)
          files = Gdk::FileList.new(LibGObject.g_value_get_boxed(value), GICrystal::Transfer::None).files
          file = nil

          files.each do |x|
            break file = x if x.uri.downcase.starts_with?("file://")
          end

          if file.nil?
            Collision::LOGGER.error { "No files starting with 'file://' given" }
            next false
          end

          self.comparefile = file
          next true
        end

        false
      end

      @compareBtn.clicked_signal.connect do
        Gtk::FileDialog.new(
          title: Gettext.gettext("Choose a File"),
          modal: true
        ).open(self, nil) do |obj, result|
          next if (file = obj.as(Gtk::FileDialog).open_finish(result)).nil?

          self.comparefile = file
        rescue ex
          Collision::LOGGER.debug { ex }
        end
      end

      self.close_request_signal.connect do
        self.hide_on_close = true if self.working && self.application.not_nil!.windows.size > 1

        false
      end
    end
  end
end

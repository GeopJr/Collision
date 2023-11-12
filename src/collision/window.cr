require "./functions/*"
require "./widgets/*"

module Collision
  @[Gtk::UiTemplate(
    resource: "/dev/geopjr/Collision/ui/application.ui",
    children: {
      "welcomeBtn",
      "mainFileChooserNative",
      "compareBtnFileChooserNative",
      "mainStack",
      "fileInfo",
      "headerbarStack",
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
    }
  )]
  class Window < Adw::ApplicationWindow
    include Gtk::WidgetTemplate

    @hash_rows = Hash(Symbol, Widgets::HashRow).new
    @headerbarStack : Gtk::Stack
    @welcomeBtn : Gtk::Button
    @compareBtn : Gtk::Button
    @compareBtnImage : Gtk::Image
    @compareBtnLabel : Gtk::Label
    @compareBtnStack : Gtk::Stack
    @openFileBtn : Gtk::Button
    @mainFileChooserNative : Gtk::FileChooserNative
    @compareBtnFileChooserNative : Gtk::FileChooserNative
    @mainStack : Gtk::Stack
    @fileInfo : Adw::StatusPage
    @switcher_bar : Adw::ViewSwitcherBar

    @verifyOverlayLabel : Gtk::Label
    @verifyTextView : Gtk::TextView
    @verifyFeedback : Gtk::Image

    @hash_results = Hash(Symbol, String).new

    def file=(filepath : Path)
      Collision::LOGGER.debug { "File set: \"#{filepath}\"" }

      @fileInfo.title = filepath.basename.to_s
      @fileInfo.description = Collision::FileUtils.real_path(filepath)

      Collision::LOGGER.debug { "Begin generating hashes" }
      Collision::Checksum.generate(filepath.to_s) do |res|
        sleep 500.milliseconds
        GLib.idle_add do
          res.each do |hash_type, hash_value|
            @hash_results[hash_type] = hash_value
            @hash_rows[hash_type].subtitle = hash_value.size < 8 ? hash_value : Collision::Checksum.split_by_4(hash_value)
          end

          @mainStack.visible_child_name = "results"
          @headerbarStack.visible_child_name = "switcher"
          @openFileBtn.visible = true
          @switcher_bar.visible = true

          false
        end
      end
    end

    # For Gio::File.
    # Should be used instead of Collision#file=(filepath : Path)
    # unless path is a File and exists.
    def file=(file : Gio::File)
      Collision::FileUtils.file?(file.path.not_nil!)
      self.file = file.path.not_nil!
    end

    def on_open_btn_clicked
      @mainFileChooserNative.show
    end

    def on_drop(file : Gio::File)
      loading
      self.file = file
    end

    def loading
      @mainStack.visible_child_name = "spinner"
      @headerbarStack.visible_child_name = "empty"
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
    end

    def handle_input_change(text : String)
      result = @hash_results.values.includes?(text.downcase.gsub(' ', ""))
      if text.size == 0
        @verifyOverlayLabel.visible = true
        @verifyFeedback.visible = false
        @verifyTextView.remove_css_class("success")
        @verifyTextView.remove_css_class("error")
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
    end

    # We want to only check the file contents
    # IF the file is smaller than the size below.
    # We want to avoid loading a huge file in
    # memory but also avoid false-positives.
    MAX_COMPARE_READ_SIZE = 10000 # in bytes

    def comparefile=(file : Gio::File)
      Collision::LOGGER.debug { "Begin comparing tool" }
      file_path = file.path.not_nil!
      Collision::FileUtils.file?(file_path)

      @compareBtnStack.visible_child_name = "spinner"
      @compareBtn.remove_css_class("success")
      @compareBtn.remove_css_class("error")

      @compareBtnLabel.label = file_path.basename.to_s
      Collision::Checksum.spawn do
        compareFileSHA256 = Collision::Checksum.calculate(:sha256, file.path.to_s)
        result = @hash_results[:sha256] == compareFileSHA256
        result = Collision::FileUtils.compare_content(file_path, @hash_results.values) if !result && File.size(file_path) < MAX_COMPARE_READ_SIZE
        classes = Collision::Feedback.class(result)

        sleep 500.milliseconds

        GLib.idle_add do
          @compareBtnStack.visible_child_name = "image"

          @compareBtnImage.icon_name = Collision::Feedback.icon(result)
          @compareBtn.add_css_class(classes[:add])
          @compareBtn.remove_css_class(classes[:remove])

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
        hashrow.clicked_signal.connect(->copy_btn_cb(String))
        @hash_rows[:{{hash}}] = hashrow
      {% end %}
    end

    def initialize
      super()

      @hash_row_container = Gtk::ListBox.cast(template_child("hash_row_container"))
      setup_hashrows

      @verifyOverlayLabel = Gtk::Label.cast(template_child("verifyOverlayLabel"))
      @verifyTextView = Gtk::TextView.cast(template_child("verifyTextView"))
      @verifyFeedback = Gtk::Image.cast(template_child("verifyFeedback"))

      @mainStack = Gtk::Stack.cast(template_child("mainStack"))
      @headerbarStack = Gtk::Stack.cast(template_child("headerbarStack"))
      @switcher_bar = Adw::ViewSwitcherBar.cast(template_child("switcher_bar"))

      @welcomeBtn = Gtk::Button.cast(template_child("welcomeBtn"))
      @fileInfo = Adw::StatusPage.cast(template_child("fileInfo"))
      @openFileBtn = Gtk::Button.cast(template_child("openFileBtn"))

      @compareBtn = Gtk::Button.cast(template_child("compareBtn"))
      @compareBtnImage = Gtk::Image.cast(template_child("compareBtnImage"))
      @compareBtnLabel = Gtk::Label.cast(template_child("compareBtnLabel"))
      @compareBtnStack = Gtk::Stack.cast(template_child("compareBtnStack"))

      @mainFileChooserNative = Gtk::FileChooserNative.cast(template_child("mainFileChooserNative"))
      @compareBtnFileChooserNative = Gtk::FileChooserNative.cast(template_child("compareBtnFileChooserNative"))
      @mainFileChooserNative.transient_for = self
      @compareBtnFileChooserNative.transient_for = self

      @verifyTextView.buffer.notify_signal["text"].connect do
        Collision::LOGGER.debug { "Verify tool notify event" }

        handle_input_change(@verifyTextView.buffer.text)
      end

      @mainFileChooserNative.response_signal.connect do |response|
        next unless response == -3

        self.file = @mainFileChooserNative.file.not_nil!
        loading
      rescue ex
        Collision::LOGGER.debug { ex }
      end

      @compareBtnFileChooserNative.response_signal.connect do |response|
        next unless response == -3

        self.comparefile = @compareBtnFileChooserNative.file.not_nil!
      rescue ex
        Collision::LOGGER.debug { ex }
      end

      @welcomeBtn.clicked_signal.connect(->on_open_btn_clicked)
      @openFileBtn.clicked_signal.connect(->on_open_btn_clicked)

      @mainStack.add_controller(Collision::DragNDrop.new(->on_drop(Gio::File)).controller)
      @compareBtn.add_controller(Collision::DragNDrop.new(->comparefile=(Gio::File)).controller)

      @compareBtn.clicked_signal.connect do
        @compareBtnFileChooserNative.show
      end
    end
  end
end

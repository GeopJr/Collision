# compare_content is a macro
# for the sake of having it
# available on tests without
# initializing Gtk
macro compare_content_macro
  def compare_content(file_path : Path | String) : Bool
    Collision::LOGGER.debug { "Begin comparing content" }
    res = false

    File.open(file_path) do |file_io|
      file_io.each_line do |line|
        break res = true if line.split(' ').any? { |word| @hash_list.includes?(word.downcase) }
      end
    end

    Collision::LOGGER.debug { "Finished comparing content" }
    res
  end
end

module Collision::Widgets
  class Tools::Compare < Collision::Tool
    # We want to only check the file contents
    # IF the file is smaller than the size below.
    # We want to avoid loading a huge file in
    # memory but also avoid false-positives
    MAX_COMPARE_READ_SIZE = 10000 # in bytes

    getter widget : Gtk::Button
    @compare_feedback_spinner : Gtk::Spinner
    @compare_feedback_image : Gtk::Image
    @compare_feedback_label : Gtk::Label
    @compare_file_chooser_native : Gtk::FileChooserNative = Gtk::FileChooserNative.new(
      title: Gettext.gettext("Choose a File"),
      modal: true
    )

    def initialize(@hash_list : HashList)
      @widget = Gtk::Button.new(
        tooltip_text: Gettext.gettext("Select Another File to Check Against"),
        height_request: 125,
        use_underline: true,
        css_classes: {"card-like"}
      )

      compare_feedback_container = Gtk::Box.new(
        orientation: Gtk::Orientation::Vertical,
        halign: Gtk::Align::Center,
        spacing: 12,
        valign: Gtk::Align::Center
      )

      @compare_feedback_image = Gtk::Image.new(
        icon_name: "paper-symbolic",
        pixel_size: 36
      )

      @compare_feedback_label = Gtk::Label.new(
        label: Gettext.gettext("Choose File..."),
        max_width_chars: 15,
        ellipsize: Pango::EllipsizeMode::End
      )

      @compare_feedback_spinner = Gtk::Spinner.new(
        spinning: true,
        halign: Gtk::Align::Center,
        width_request: 36,
        height_request: 36,
        visible: false
      )

      compare_feedback_container.append(@compare_feedback_spinner)
      compare_feedback_container.append(@compare_feedback_image)
      compare_feedback_container.append(@compare_feedback_label)
      @widget.child = compare_feedback_container

      setup_file_chooser
      bind
    end

    private def bind
      @widget.clicked_signal.connect do
        @compare_file_chooser_native.show
      end
    end

    private def setup_file_chooser
      @compare_file_chooser_native.transient_for = APP.active_window

      @compare_file_chooser_native.response_signal.connect do |response|
        next unless response == -3 && !(gio_file = @compare_file_chooser_native.file).nil?

        self.file = gio_file
      rescue ex
        LOGGER.debug { ex }
      end
    end

    def file=(file : Gio::File)
      return if (file_path = file.path).nil?
      LOGGER.debug { "Begin comparing tool" }
      Collision.file?(file_path)

      @compare_feedback_spinner.visible = true
      @compare_feedback_image.visible = false
      @widget.remove_css_class("success")
      @widget.remove_css_class("error")

      @compare_feedback_label.label = file_path.basename.to_s
      Collision::Functions.spawn do
        compare_file_SHA256 = (Collision::Functions::Checksum.new).calculate(HashFunction::SHA256, file.path.to_s)
        result = @hash_list.includes?(compare_file_SHA256)
        result = compare_content(file_path) if !result && File.size(file_path) < MAX_COMPARE_READ_SIZE
        classes = Collision::Functions::Feedback.class(result)

        sleep 500.milliseconds
        @compare_feedback_spinner.visible = false
        @compare_feedback_image.visible = true
        @compare_feedback_image.icon_name = Collision::Functions::Feedback.icon(result)
        @widget.add_css_class(classes[:add])
        @widget.remove_css_class(classes[:remove])

        LOGGER.debug { "Finished comparing tool" }
      end
    end

    compare_content_macro

    def clear
      @compare_feedback_label.label = Gettext.gettext("Choose File...")
      @widget.remove_css_class("success")
      @widget.remove_css_class("error")
      @compare_feedback_image.icon_name = "paper-symbolic"
    end
  end
end

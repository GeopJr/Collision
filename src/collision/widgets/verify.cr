module Collision::Widgets
  class Tools::Verify < Collision::Tool
    getter widget : Gtk::Overlay
    @verify_input : Gtk::TextView
    @verify_input_placeholder : Gtk::Label
    @verify_feedback : Gtk::Image

    def initialize(@hash_list : HashList)
      @widget = Gtk::Overlay.new
      @verify_feedback = Gtk::Image.new(
        icon_name: "test-pass-symbolic",
        pixel_size: 16,
        halign: Gtk::Align::End,
        valign: Gtk::Align::End,
        margin_end: 5,
        margin_bottom: 5,
        sensitive: false,
        visible: false
      )

      @widget.add_overlay(@verify_feedback)

      verify_input_overlay = Gtk::Overlay.new
      @verify_input_placeholder = Gtk::Label.new(
        label: Gettext.gettext("MD5,SHA-1,SHA-256 or SHA-512 Hash"),
        halign: Gtk::Align::Start,
        valign: Gtk::Align::Start,
        justify: Gtk::Justification::Fill,
        margin_end: 22,
        margin_start: 14,
        margin_top: 11,
        wrap_mode: Pango::WrapMode::Char,
        wrap: true,
        sensitive: false,
        css_classes: {"monospace"}
      )
      @verify_input = Gtk::TextView.new(
        pixels_above_lines: 11,
        pixels_below_lines: 11,
        left_margin: 5,
        right_margin: 5,
        cursor_visible: false,
        height_request: 125,
        wrap_mode: Gtk::WrapMode::Char,
        accepts_tab: false,
        css_name: "entry",
        css_classes: {"card-like", "monospace"},
        tooltip_text: Gettext.gettext("Insert a MD5/SHA-1/SHA-256/SHA-512 Hash")
      )

      @verify_input.remove_css_class("view")
      @verify_input.cursor_visible = false
      @verify_input.accepts_tab = false

      scrolled_window = Gtk::ScrolledWindow.new(height_request: 125)
      scrolled_window.child = @verify_input

      verify_input_overlay.add_overlay(@verify_input_placeholder)
      verify_input_overlay.child = scrolled_window

      @verify_input.buffer.notify_signal["text"].connect do
        LOGGER.debug { "Verify tool notify event" }

        handle_input_change
      end

      @widget.child = verify_input_overlay
    end

    private def handle_input_change
      input = @verify_input.buffer.text
      if input.size == 0
        @verify_input_placeholder.visible = true
        @verify_feedback.visible = false
        @verify_input.remove_css_class("success")
        @verify_input.remove_css_class("error")
        return
      end
      result = @hash_list.includes?(input.gsub(' ', "").downcase)

      @verify_input_placeholder.visible = false
      @verify_feedback.visible = true

      classes = Collision::Feedback.class(result)

      @verify_input.add_css_class(classes[:add])
      @verify_input.remove_css_class(classes[:remove])

      @verify_feedback.icon_name = Collision::Feedback.icon(result)
      @verify_feedback.add_css_class(classes[:add])
      @verify_feedback.remove_css_class(classes[:remove])
    end

    def clear
      @verify_input.buffer.text = ""
      @verify_feedback.visible = false
    end
  end
end

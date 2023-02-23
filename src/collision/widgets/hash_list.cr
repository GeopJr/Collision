module Collision
  class Widgets::HashList
    # Generic class for a single
    # action row of the hashlist
    class Entry
      getter widget : Adw::ActionRow
      getter value : String = ""

      def initialize(@widget : Adw::ActionRow)
      end

      def clear
        @widget.subtitle = ""
        @value = ""
      end

      def hash=(values : Tuple(String, String))
        @widget.subtitle = values[0]
        @value = values[1]
      end
    end

    getter widget : Gtk::ListBox
    getter clipboard : Gdk::Clipboard

    @rows = Hash(HashFunction, Entry).new

    def initialize(@clipboard : Gdk::Clipboard)
      @widget = Gtk::ListBox.new(
        halign: Gtk::Align::Center,
        valign: Gtk::Align::Center,
        css_classes: {"content"}
      )

      HashFunction.values.each do |hash_function|
        copy_btn = Gtk::Button.new(
          icon_name: "edit-copy-symbolic",
          css_classes: {"circular"},
          tooltip_text: Gettext.gettext("Copy"),
          valign: Gtk::Align::Center
        )

        row = Adw::ActionRow.new(
          title: hash_function.to_s.sub("SHA", "SHA-"),
          selectable: false,
          subtitle_lines: 100,
          css_classes: {"hash-row"},
        )
        row.add_suffix(copy_btn)

        @rows[hash_function] = Entry.new(row)
        setup_copy_button(copy_btn, row, hash_function)
        @widget.append(row)
      end
    end

    def clear
      @rows.each_value do |row|
        row.clear
      end
    end

    def set_hash(hash_type : HashFunction, value : Tuple(String, String))
      @rows[hash_type].hash = value
    end

    def values : Array(String)
      @rows.values.map(&.value)
    end

    def includes?(hash : String) : Bool
      @rows.values.each do |row|
        return true if row.value == hash
      end

      false
    end

    private def setup_copy_button(button : Gtk::Button, row : Adw::ActionRow, hash_type : HashFunction)
      # Soft lock is being used to avoid
      # spamming the copy buttons until
      # the button feedback resets.
      soft_locked = false

      button.clicked_signal.connect do
        LOGGER.debug { "Copied #{hash_type} hash" }

        next if (subtitle = row.subtitle).nil?
        hash = subtitle.gsub(' ', "")
        success = true
        begin
          @clipboard.set(hash)
        rescue
          success = false
        end

        next if soft_locked
        soft_locked = true

        button.icon_name = Collision::Functions::Feedback.icon(success)
        feedback_class = Collision::Functions::Feedback.class(success)
        button.add_css_class(feedback_class[:add])
        Non::Blocking.spawn do
          sleep 1.1.seconds # 1 feels fast, 1.5 feels slow
          button.icon_name = "edit-copy-symbolic"
          button.remove_css_class(feedback_class[:add])
          soft_locked = false

          LOGGER.debug { "Copy button feedback reset" }
        end
      end
    end
  end
end

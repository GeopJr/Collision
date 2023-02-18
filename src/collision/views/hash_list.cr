module Collision
  class HashList
    getter widget : Gtk::ListBox
    getter clipboard : Gdk::Clipboard

    @rows : Hash(String, Adw::ActionRow) = Hash(String, Adw::ActionRow).new

    def initialize(@clipboard : Gdk::Clipboard)
      @widget = Gtk::ListBox.new(
        halign: Gtk::Align::Center,
        valign: Gtk::Align::Center
      )
      @widget.add_css_class("content")

      HASH_FUNCTIONS.each do |hash|
        copy_btn = Gtk::Button.new_from_icon_name("edit-copy-symbolic")
        copy_btn.tooltip_text = Gettext.gettext("Copy")
        copy_btn.valign = Gtk::Align::Center
        copy_btn.add_css_class("circular")

        row = Adw::ActionRow.new(
          title: hash.sub("SHA", "SHA-"),
          selectable: false,
          subtitle_lines: 100
        )
        row.add_suffix(copy_btn)
        row.add_css_class("hash-row")

        @rows[hash] = row
        setup_copy_button(copy_btn, row, hash)
        @widget.append(row)
      end
    end

    def clear
      @rows.each_value do |row|
        row.subtitle = ""
      end
    end

    # TODO ENUM HASHeS
    def set_hash(hash_type : String, value : String)
      @rows[hash_type].subtitle = value
    end

    private def setup_copy_button(button : Gtk::Button, row : Adw::ActionRow, hash_type : String)
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

        button.icon_name = Collision::Feedback.icon(success)
        feedback_class = Collision::Feedback.class(success)
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

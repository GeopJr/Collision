# Handles gschema settings

module Collision
  extend self

  module Settings
    extend self

    DEFAULT_SETTINGS = {
      window_width:     600,
      window_height:    460,
      window_maximized: false,
    }

    # Used to avoid a GLib error on runtime
    # when a key doesn't exist for whatever
    # reason.
    # Settings keys used/required.
    SETTINGS_KEYS = [
      "window-width",
      "window-height",
      "is-maximized",
    ]

    def available?(settings : Gio::Settings) : Bool
      diff = SETTINGS_KEYS - settings.list_keys
      missing = diff.empty?

      LOGGER.debug { "Missing settings: #{diff}" } unless missing

      missing
    end

    def save(window : Gtk::Window) : Bool
      return false if (settings = SETTINGS).nil? || !Collision::Settings.available?(settings)

      LOGGER.debug { "Saving settings" }

      unless window.maximized?
        settings.set_int("window-width", window.width)
        settings.set_int("window-height", window.height)
      end
      settings.set_boolean("is-maximized", window.maximized?)

      false # It has to return false so the window closes.
    end
  end

  def settings
    return Collision::Settings::DEFAULT_SETTINGS if (settings = SETTINGS).nil? || !Collision::Settings.available?(settings)

    LOGGER.debug { "Loading settings" }

    begin
      {
        window_width:     settings.int("window-width"),
        window_height:    settings.int("window-height"),
        window_maximized: settings.boolean("is-maximized"),
      }
    rescue ex
      LOGGER.debug { ex }

      Collision::Settings::DEFAULT_SETTINGS
    end
  end
end

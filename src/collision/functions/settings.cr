# Handles gschema settings

module Collision
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

  def settings_available?(settings : Gio::Settings) : Bool
    diff = SETTINGS_KEYS - settings.list_keys
    LOGGER.debug { "Missing settings: #{diff}" }

    diff.empty?
  end

  def get_settings
    LOGGER.debug { "Loading settings" }

    return DEFAULT_SETTINGS if (settings = SETTINGS).nil? || !settings_available?(settings)

    begin
      {
        window_width:     settings.int("window-width"),
        window_height:    settings.int("window-height"),
        window_maximized: settings.boolean("is-maximized"),
      }
    rescue ex
      LOGGER.debug { ex }

      DEFAULT_SETTINGS
    end
  end

  def save_settings(window : Gtk::Window) : Bool
    LOGGER.debug { "Saving settings" }

    return false if (settings = SETTINGS).nil? || !settings_available?(settings)

    unless window.maximized?
      settings.set_int("window-width", window.width)
      settings.set_int("window-height", window.height)
    end
    settings.set_boolean("is-maximized", window.maximized?)

    false
  end
end

# Handles gschema settings

module Collision
  extend self

  module Settings
    extend self

    DEFAULT_SETTINGS = {
      window_width:            600,
      window_height:           460,
      window_maximized:        false,
      disabled_hash_functions: [] of String,
    }

    # Used to avoid a GLib error on runtime
    # when a key doesn't exist for whatever
    # reason.
    # Settings keys used/required.
    SETTINGS_KEYS = [
      "window-width",
      "window-height",
      "is-maximized",
      "disabled-hash-functions",
    ]

    def available?(settings : Gio::Settings) : Bool
      {% if !flag?(:debug) && flag?(:release) %}
        return true # it's a packaging error if a key doesn't exist
      {% end %}

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

    def update_disabled_hash_functions(dhf : Enumerable(String))
      if (settings = SETTINGS).nil? || !Collision::Settings.available?(settings)
        # On devel, when gschema is not installed, update the default value instead
        DEFAULT_SETTINGS[:disabled_hash_functions].replace(dhf)
        update_safe_disabled_hash_functions(dhf)
        return
      end

      LOGGER.debug { "Saving disabled hash functions: #{dhf}" }

      settings.set_strv("disabled-hash-functions", dhf)
      update_safe_disabled_hash_functions(dhf)
    end

    # Let's cache a symbol array when updating dhf
    # instead of calculating them all the time
    @@safe_disabled_hash_functions = [] of Symbol
    update_safe_disabled_hash_functions

    def safe_disabled_hash_functions
      @@safe_disabled_hash_functions
    end

    private def update_safe_disabled_hash_functions(sdhf : Enumerable(String)? = nil)
      if sdhf.nil?
        if (settings = SETTINGS).nil? || !Collision::Settings.available?(settings)
          sdhf = DEFAULT_SETTINGS[:disabled_hash_functions]
        else
          sdhf = settings.strv("disabled-hash-functions")
        end
      end

      if sdhf.size == 0
        @@safe_disabled_hash_functions.clear
        return
      end

      symbol_arr = [] of Symbol

      Collision::HASH_FUNCTIONS.each_key do |k|
        next if k == Collision::VERIFICATION_HASH_FUNCTION
        symbol_arr << k if sdhf.includes?(k.to_s)
      end

      @@safe_disabled_hash_functions = symbol_arr
    end
  end

  def settings
    return Collision::Settings::DEFAULT_SETTINGS if (settings = SETTINGS).nil? || !Collision::Settings.available?(settings)

    LOGGER.debug { "Loading settings" }

    begin
      {
        window_width:            settings.int("window-width"),
        window_height:           settings.int("window-height"),
        window_maximized:        settings.boolean("is-maximized"),
        disabled_hash_functions: settings.strv("disabled-hash-functions"),
      }
    rescue ex
      LOGGER.debug { ex }

      Collision::Settings::DEFAULT_SETTINGS
    end
  end
end

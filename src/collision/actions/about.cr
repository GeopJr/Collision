module Collision::Action
  class About
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application)
      @action = Gio::SimpleAction.new("about", nil)

      @action.activate_signal.connect do
        Adw.show_about_window(
          APP.active_window,
          # name: "About Collision",
          application: APP,
          application_name: Gettext.gettext("Collision"),
          application_icon: "dev.geopjr.Collision",
          version: VERSION,
          copyright: "© 2021 Evangelos Paterakis",
          # website: "https://github.com/GeopJr/Collision",
          issue_url: "https://github.com/GeopJr/Collision/issues",
          developer_name: "Evangelos \"GeopJr\" Paterakis",
          artists: {"Tobias Bernard"},
          designers: {"Tobias Bernard", "Evangelos \"GeopJr\" Paterakis"},
          translator_credits: Gettext.gettext("translator-credits"),
          license_type: Gtk::License::Bsd,
          debug_info: TROUBLESHOOTING.to_s.gsub(/File set: .+\n/, "File set: REDACTED\n"), # Attempt to redact file paths.
          debug_info_filename: "Collision-#{Time.utc.to_unix_ms}.txt"
        )
      end

      app.add_action(@action)
    end
  end
end

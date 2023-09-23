class Collision::Action::About < Collision::Action
  @app : Adw::Application

  def initialize(app : Adw::Application)
    @app = app
    super(app, "about", {"F1"})
  end

  def on_activate
    Adw.show_about_window(
      @app.active_window,
      application: @app,
      application_name: Gettext.gettext("Collision"),
      application_icon: "dev.geopjr.Collision",
      version: VERSION,
      copyright: "© 2021 Evangelos Paterakis",
      # website: "https://github.com/GeopJr/Collision",
      issue_url: "https://github.com/GeopJr/Collision/issues",
      developer_name: "Evangelos \"GeopJr\" Paterakis",
      artists: {"Tobias Bernard"},
      designers: {"Tobias Bernard"},
      translator_credits: Gettext.gettext("translator-credits"),
      license_type: Gtk::License::Bsd,
      debug_info: TROUBLESHOOTING.to_s.gsub(/File set: .+\n/, "File set: REDACTED\n"), # Attempt to redact file paths.
      debug_info_filename: "Collision-#{Time.utc.to_unix_ms}.txt"
    )
  end
end

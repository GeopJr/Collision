class Collision::Action::About < Collision::Action
  @app : Adw::Application

  def initialize(app : Adw::Application)
    @app = app
    super(app, "about", {"F1"})
  end

  def on_activate
    dialog = Adw::AboutDialog.new(
      application_name: Gettext.gettext("Collision"),
      application_icon: "dev.geopjr.Collision",
      version: VERSION,
      copyright: "© 2021 Evangelos Paterakis",
      website: "https://collision.geopjr.dev",
      issue_url: "https://github.com/GeopJr/Collision/issues",
      developer_name: "Evangelos \"GeopJr\" Paterakis",
      artists: {"Tobias Bernard"},
      designers: {"Tobias Bernard"},
      translator_credits: Gettext.gettext("translator-credits"),
      license_type: Gtk::License::Bsd,
      debug_info: TROUBLESHOOTING.to_s.gsub(/File set: .+\n/, "File set: REDACTED\n"), # Attempt to redact file paths.
      debug_info_filename: "Collision-#{Time.utc.to_unix_ms}.txt"
    )
    dialog.add_other_app("dev.geopjr.Archives", Gettext.gettext("Archives"), Gettext.gettext("Create and view web archives"))
    dialog.add_other_app("dev.geopjr.Calligraphy", Gettext.gettext("Calligraphy"), Gettext.gettext("Turn text into ASCII banners"))
    dialog.add_other_app("dev.geopjr.Tuba", Gettext.gettext("Tuba"), Gettext.gettext("Browse the Fediverse"))
    dialog.add_other_app("dev.geopjr.Turntable", Gettext.gettext("Turntable"), Gettext.gettext("Scrobble your music"))

    dialog.present(@app.active_window)
  end
end

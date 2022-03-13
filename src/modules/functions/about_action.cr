module Collision
  extend self

  def about_action(app : Adw::Application)
    action = Gio::SimpleAction.new("about", nil)
    app.add_action(action)

    action.activate_signal.connect do
      Gtk.show_about_dialog(APP.active_window, name: "About Collision",
        application: APP,
        program_name: "Collision",
        version: VERSION,
        logo_icon_name: "dev.geopjr.Collision",
        copyright: "© 2021 Evangelos Paterakis",
        website: "https://github.com/GeopJr/Collision",
        authors: ["Evangelos \"GeopJr\" Paterakis"],
        artists: ["Tobias Bernard", "Evangelos \"GeopJr\" Paterakis"],
        translator_credits: THANKS,
        license_type: Gtk::License::Bsd)
    end
  end
end

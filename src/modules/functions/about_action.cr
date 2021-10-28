module Hashbrown
  extend self

  def about_action(app : Adw::Application)
    action = Gio::SimpleAction.new("about", nil)
    app.add_action(action)

    action.activate_signal.connect do
      Gtk.show_about_dialog(APP.active_window, name: "About Hashbrown",
        application: APP,
        program_name: "Hashbrown",
        version: VERSION,
        logo_icon_name: "dev.geopjr.Hashbrown",
        copyright: "© 2021 Evangelos Paterakis",
        website: "https://github.com/GeopJr/Hashbrown",
        authors: ["Evangelos \"GeopJr\" Paterakis"],
        artists: ["Evangelos \"GeopJr\" Paterakis"],
        translator_credits: THANKS,
        license_type: Gtk::License::Bsd)
    end
  end
end

module Collision::Action
  class About
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application)
      @action = Gio::SimpleAction.new("about", nil)

      @action.activate_signal.connect do
        Gtk.show_about_dialog(
          APP.active_window,
          name: "About Collision",
          application: APP,
          program_name: Gettext.gettext("Collision"),
          version: VERSION,
          logo_icon_name: "dev.geopjr.Collision",
          copyright: "© 2021-2022 Evangelos Paterakis",
          website: "https://github.com/GeopJr/Collision",
          authors: ["Evangelos \"GeopJr\" Paterakis"],
          artists: ["Tobias Bernard", "Evangelos \"GeopJr\" Paterakis"],
          translator_credits: Gettext.gettext("translator-credits"),
          license_type: Gtk::License::Bsd
        )
      end

      app.add_action(@action)
    end
  end
end

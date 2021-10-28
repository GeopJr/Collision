# Opens url in default browser

module Hashbrown
  extend self

  def hashinfo_action(app : Adw::Application)
    action = Gio::SimpleAction.new("hashinfo", nil)
    app.add_action(action)

    action.activate_signal.connect do
      LibGio.g_app_info_launch_default_for_uri(ARTICLE, Pointer(Void).null)
    end
  end
end

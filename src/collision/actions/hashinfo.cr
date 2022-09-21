# Opens url in default browser

module Collision::Action
  class HashInfo
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application, window_id : UInt32)
      @action = Gio::SimpleAction.new("hashinfo", nil)

      @action.activate_signal.connect do
        parent = APP.active_window.nil? ? APP.window_by_id(window_id) : APP.active_window
        LibGtk.gtk_show_uri(parent.not_nil!, ARTICLE, Gdk::CURRENT_TIME)
      end

      app.add_action(action)
    end
  end
end

# Opens url in default browser

module Collision::Action
  class HashInfo
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application, window_id : UInt32)
      @action = Gio::SimpleAction.new("hashinfo", nil)

      @action.activate_signal.connect do
        parent = app.active_window.nil? ? app.window_by_id(window_id) : app.active_window
        LibGtk.gtk_show_uri(parent, ARTICLE, Gdk::CURRENT_TIME) if !(parent).nil?
      end

      app.add_action(action)
    end
  end
end

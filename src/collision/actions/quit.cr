# Exits the app

module Collision::Action
  class Quit
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application, window_id : UInt32)
      @action = Gio::SimpleAction.new("quit", nil)

      @action.activate_signal.connect do
        main_window = app.active_window.nil? ? app.window_by_id(window_id) : app.active_window
        main_window.close if main_window
        app.quit
      end

      app.add_action(action)
    end
  end
end

# Exits the app

module Collision::Action
  class Quit
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application, window_id : UInt32)
      @action = Gio::SimpleAction.new("quit", nil)

      @action.activate_signal.connect do
        main_window = APP.active_window.nil? ? APP.window_by_id(window_id) : APP.active_window
        main_window.close if main_window
        APP.quit
      end

      app.add_action(action)
    end
  end
end

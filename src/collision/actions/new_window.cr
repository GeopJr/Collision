# Opens a new main file

module Collision::Action
  class NewWindow
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application)
      @action = Gio::SimpleAction.new("new-window", nil)

      @action.activate_signal.connect do
        app.activate
      end

      app.add_action(action)
    end
  end
end

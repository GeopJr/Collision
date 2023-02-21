# Creates a new window

module Collision::Action
  class NewWindow
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application)
      @action = Gio::SimpleAction.new("new-window", nil)

      # Call Adw::Application#activate
      @action.activate_signal.connect do
        app.activate
      end

      app.add_action(action)
    end
  end
end

# Opens a new main file

module Collision::Action
  class Open
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application)
      @action = Gio::SimpleAction.new("open-file", nil)

      @action.activate_signal.connect do
        (Collision::Welcomer.passed? ? MAIN_FILE_CHOOSER_NATIVE : WELCOMER_FILE_CHOOSER_NATIVE).show
      end

      app.add_action(action)
    end
  end
end

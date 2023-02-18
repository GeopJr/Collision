# Opens a new main file

module Collision::Action
  class Open
    getter action : Gio::SimpleAction

    def initialize(app : Adw::Application, file_chooser : Gtk::FileChooserNative)
      @action = Gio::SimpleAction.new("open-file", nil)

      @action.activate_signal.connect do
        file_chooser.show
      end

      app.add_action(action)
    end
  end
end

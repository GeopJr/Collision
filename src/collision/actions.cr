abstract class Collision::Action
  def initialize(app : Adw::Application, name : String, accels : Enumerable(String)? = nil)
    action = Gio::SimpleAction.new(name, nil)
    action.activate_signal.connect do
      on_activate
    end

    unless accels.nil? || accels.size == 0
      app.set_accels_for_action("app.#{name}", accels)
    end

    app.add_action(action)
  end

  abstract def initialize(app : Adw::Application)
  abstract def on_activate
end

require "./actions/*"

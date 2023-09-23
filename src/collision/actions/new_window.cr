class Collision::Action::NewWindow < Collision::Action
  @app : Adw::Application

  def initialize(app : Adw::Application)
    @app = app
    super(app, "new-window", {"<Ctrl>N"})
  end

  def on_activate
    @app.activate
  end
end

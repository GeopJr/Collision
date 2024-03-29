class Collision::Action::Quit < Collision::Action
  @app : Adw::Application

  def initialize(app : Adw::Application)
    @app = app
    super(app, "quit", {"<Ctrl>Q"})
  end

  def on_activate
    @app.quit
  end
end

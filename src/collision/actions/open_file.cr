class Collision::Action::OpenFile < Collision::Action
  setter cb : Proc(Nil)?

  def initialize(app : Adw::Application)
    super(app, "open-file", {"<Ctrl>O"})
  end

  def on_activate
    @cb.try &.call
  end
end

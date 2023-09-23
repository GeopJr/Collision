class Collision::Action::HashInfo < Collision::Action
  def initialize(app : Adw::Application)
    super(app, "hashinfo")
  end

  def on_activate
    begin
      Gio.app_info_launch_default_for_uri(ARTICLE, nil)
    rescue ex
      LOGGER.debug { ex }
    end
  end
end

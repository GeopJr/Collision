module Collision
  APP   = Adw::Application.new("dev.geopjr.Collision", Gio::ApplicationFlags::HandlesOpen | Gio::ApplicationFlags::NonUnique)
  QUEUE = [] of Gio::File

  def self.activate(app : Adw::Application)
    window_settings = Collision.settings

    # Setup window.
    window = Adw::ApplicationWindow.new(
      application: app,
      name: "mainWindow",
      title: Gettext.gettext("Collision"),
      width_request: 360,
      height_request: 360,
      default_width: window_settings[:window_width],
      default_height: window_settings[:window_height],
      maximized: window_settings[:window_maximized]
    )
    window.close_request_signal.connect(->Collision::Settings.save(Gtk::Window))

    root = Adw::ViewStack.new
    main_view = Collision::Views::Main.new(root)
    headerbar = Collision::Widgets::Headerbar.new(main_view.file_util, main_view.switcher_title)

    root.notify_signal["visible-child-name"].connect do
      is_main = root.visible_child_name == "main"
      headerbar.open_file_button.visible = is_main
      main_view.switcher_visible = is_main
      main_view.clear if is_main
    end

    window_box = Gtk::Box.new(Gtk::Orientation::Vertical, 0)
    window_box.append(headerbar.widget)
    window_box.append(root)

    # Setup actions.
    Collision::Action::About.new(app, window.id)
    Collision::Action::HashInfo.new(app, window.id)
    Collision::Action::Quit.new(app, window.id)
    Collision::Action::Open.new(app, headerbar.open_file_file_chooser_native)
    Collision::Action::NewWindow.new(app)

    # Setup accelerators.
    app.set_accels_for_action("app.quit", {"<Control>q"})
    app.set_accels_for_action("window.close", {"<Control>w"})
    app.set_accels_for_action("app.new-window", {"<Control>n"})
    app.set_accels_for_action("app.open-file", {"<Control>o"})

    {% if flag?(:debug) || !flag?(:release) %}
      window.add_css_class("devel")
    {% end %}

    window.content = window_box
    window.present

    LOGGER.debug { "Window activated" }
    LOGGER.debug { "Settings: #{window_settings}" }

    root.add_named((Collision::Views::Welcomer.new(main_view.file_util, headerbar.open_file_file_chooser_native)).widget, "welcomer")
    root.add_named((Collision::Views::Loading.new).widget, "loading")
    root.add_named(main_view.widget, "main")

    if QUEUE.size > 0 && !(file = QUEUE.shift?).nil?
      main_view.file_util.file = file
    end
  end

  EMIT_QUEUE = ->do
    return unless QUEUE.size > 0

    APP.activate_signal.emit
  end

  # Handles the open signal. It first calls activate and then
  # if there are files passed (that exist and are not dirs)
  # it sets the first one (since multiple can be passed)
  # as the Collision::Welcomer's file.
  def self.open_with(app : Adw::Application, files : Enumerable(Gio::File), hint : String)
    files.each do |file|
      next unless !(file_path = file.path).nil? && Collision.file?(file_path, false)

      QUEUE << file
      break if QUEUE.size >= 4
    end

    APP.activate_signal.emit

    nil
  end

  APP.activate_signal.connect(->activate(Adw::Application))
  APP.open_signal.connect(->open_with(Adw::Application, Enumerable(Gio::File), String))

  # ARGV but without flags, passed to Application.
  clean_argv = [PROGRAM_NAME].concat(ARGV.reject(&.starts_with?('-')))
  exit(APP.run(clean_argv))
end

module Collision
  APP = Adw::Application.new("dev.geopjr.Collision", Gio::ApplicationFlags::HandlesOpen)

  def self.activate(app : Adw::Application, file : Gio::File? = nil)
    # Setup window.
    window = Adw::ApplicationWindow.new(app)
    window_settings = Collision.settings

    window.name = "mainWindow"
    window.title = Gettext.gettext("Collision")
    window.close_request_signal.connect(->Collision::Settings.save(Gtk::Window))
    window.width_request = 360
    window.height_request = 360
    window.set_default_size(window_settings[:window_width], window_settings[:window_height])
    window.maximize if window_settings[:window_maximized]

    root = Adw::ViewStack.new
    main_view = Collision::Main.new(root)

    headerbar = Collision::Headerbar.new(main_view.file_util, main_view.switcher_title)
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
    Collision::Action::About.new(app)
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
    # @@activated = true

    LOGGER.debug { "Window activated" }
    LOGGER.debug { "Settings: #{window_settings}" }

    welcomer = Collision::Welcomer.new(main_view.file_util)
    root.add_named(welcomer.widget, "welcomer")
    root.add_named((Collision::Loading.new).widget, "loading")
    root.add_named(main_view.widget, "main")

    welcomer.file = file unless file.nil?
  end

  # Handles the open signal. It first calls activate and then
  # if there are files passed (that exist and are not dirs)
  # it sets the first one (since multiple can be passed)
  # as the Collision::Welcomer's file.
  def self.open_with(app : Adw::Application, files : Enumerable(Gio::File), hint : String)
    if files.size > 0 && !(file_path = files[0].path).nil? && Collision.file?(file_path, false)
      activate(app, files[0])
    else
      activate(app)
    end

    nil
  end

  # APP.startup_signal.connect(->startup(Adw::Application))
  APP.activate_signal.connect(->activate(Adw::Application))
  APP.open_signal.connect(->open_with(Adw::Application, Enumerable(Gio::File), String))

  # ARGV but without flags, passed to Application.
  clean_argv = [PROGRAM_NAME].concat(ARGV.reject(&.starts_with?('-')))
  exit(APP.run(clean_argv))
end

module Collision
  @@main_window_id = 0_u32
  @@activated = false

  def activate(app : Adw::Application)
    # Put window on focus if already exists.
    main_window = APP.window_by_id(@@main_window_id)
    return main_window.present if main_window

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

    @@main_window_id = window.id

    # Initial layout.
    root = Adw::StatusPage.cast(B_UI["welcomer"])
    headerbar = Collision::Headerbar.new

    WINDOW_BOX.append(headerbar.widget)
    WINDOW_BOX.append(root)

    # Setup file choosers.
    WELCOMER_FILE_CHOOSER_NATIVE.transient_for = window
    TOOL_COMPARE_FILE_CHOOSER_NATIVE.transient_for = window
    MAIN_FILE_CHOOSER_NATIVE.transient_for = window

    MAIN_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
      next unless response == -3

      Collision.file = MAIN_FILE_CHOOSER_NATIVE.file.not_nil!
    rescue ex
      LOGGER.debug { ex }
    end

    OPEN_FILE_BUTTON.clicked_signal.connect do
      MAIN_FILE_CHOOSER_NATIVE.show
    end

    # Setup actions.
    Collision::Action::About.new(app)
    Collision::Action::HashInfo.new(app, window.id)
    Collision::Action::Quit.new(app, window.id)
    Collision::Action::Open.new(app)

    # Setup accelerators.
    app.set_accels_for_action("app.quit", {"<Control>q", "<Control>w"})
    app.set_accels_for_action("app.open-file", {"<Control>o"})

    # Setup clipboard.
    Collision::Clipboard.new(window, COPY_BUTTONS)

    # Setup views.
    Collision::Welcomer.init
    Collision::Compare.init
    Collision::Verify.init

    {% if flag?(:debug) || !flag?(:release) %}
      window.add_css_class("devel")
    {% end %}

    window.content = WINDOW_BOX
    window.present
    @@activated = true

    LOGGER.debug { "Window activated" }
    LOGGER.debug { "Settings: #{window_settings}" }
  end

  # Sets up the verify tab so it's responsive
  # on window size change as well as its initial
  # state.
  def startup(app : Adw::Application)
    tools_grid_first_child = TOOLS_GRID.first_child
    tools_grid_last_child = TOOLS_GRID.last_child
    BOTTOM_TABS.notify_signal["reveal"].connect do
      next if tools_grid_last_child.nil? || tools_grid_first_child.nil?
      row = 0
      column = 1
      if BOTTOM_TABS.reveal
        row = 1
        column = 0
      end

      TOOLS_GRID.remove(tools_grid_last_child)
      TOOLS_GRID.attach(tools_grid_last_child, column, row, 1, 1)
    end

    TOOL_COMPARE_BUTTON_SPINNER.visible = false
    TOOL_COMPARE_BUTTON_FEEDBACK.prepend(TOOL_COMPARE_BUTTON_SPINNER)
    TOOL_VERIFY_INPUT.remove_css_class("view")
    TOOL_VERIFY_INPUT.cursor_visible = false
    TOOL_VERIFY_INPUT.accepts_tab = false

    scrolled_window = Gtk::ScrolledWindow.new(height_request: 125)
    scrolled_window.child = TOOL_VERIFY_INPUT

    TOOL_VERIFY_OVERLAY.child = scrolled_window
  end

  # Handles the open signal. It first calls activate and then
  # if there are files passed (that exist and are not dirs)
  # it sets the first one (since multiple can be passed)
  # as the Collision::Welcomer's file.
  def open_with(app : Adw::Application, files : Enumerable(Gio::File), hint : String)
    activate(app) unless @@activated

    if files.size > 0 && Collision.file?(files[0].path.not_nil!, false)
      (Collision::Welcomer.passed? ? Collision : Collision::Welcomer).file = files[0]
    end

    nil
  end

  APP.startup_signal.connect(->startup(Adw::Application))
  APP.activate_signal.connect(->activate(Adw::Application))
  APP.open_signal.connect(->open_with(Adw::Application, Enumerable(Gio::File), String))

  # ARGV but without flags, passed to Application.
  clean_argv = [PROGRAM_NAME].concat(ARGV.reject { |x| x.starts_with?('-') })
  exit(APP.run(clean_argv))
end

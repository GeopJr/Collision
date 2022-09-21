module Collision
  @@main_window_id = 0_u32

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
      Collision::Feedback.reset

      set_file(MAIN_FILE_CHOOSER_NATIVE.file.not_nil!.path.not_nil!)
    end

    OPEN_FILE_BUTTON.clicked_signal.connect do
      MAIN_FILE_CHOOSER_NATIVE.show
    end

    # Setup actions.
    Collision::Action::About.new(app)
    Collision::Action::HashInfo.new(app, window.id)

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

  APP.startup_signal.connect(->startup(Adw::Application))
  APP.activate_signal.connect(->activate(Adw::Application))

  exit(APP.run(nil))
end

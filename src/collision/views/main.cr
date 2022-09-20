module Collision
  @@main_window_id = 0_u32

  def activate(app : Adw::Application)
    main_window = APP.window_by_id(@@main_window_id)
    return main_window.present if main_window

    window = Adw::ApplicationWindow.new(app)
    window_settings = Collision.get_settings

    window.name = "mainWindow"
    window.title = Gettext.gettext("Collision")
    window.close_request_signal.connect(->Collision.save_settings(Gtk::Window))
    window.width_request = 360
    window.height_request = 360
    window.set_default_size(window_settings[:window_width], window_settings[:window_height])
    window.maximize if window_settings[:window_maximized]

    @@main_window_id = window.id

    Collision.generate_headbar
    root = Adw::StatusPage.cast(B_UI["welcomer"])

    WINDOW_BOX.append(HEADERBAR)
    WINDOW_BOX.append(root)

    Collision.about_action(app)
    Collision.hashinfo_action(app, @@main_window_id)

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

    clipboard = window.clipboard
    COPY_BUTTONS.each do |hash_type, btn|
      soft_locked = false
      btn.clicked_signal.connect do
        LOGGER.debug { "Copied #{hash_type} hash" }

        hash = CLIPBOARD_HASH[hash_type]
        success = true
        begin
          clipboard.set(hash)
        rescue
          success = false
        end

        next if soft_locked
        soft_locked = true

        btn.icon_name = Collision.icon(success)
        feedback_class = success ? "success" : "error"
        btn.add_css_class(feedback_class)
        Non::Blocking.spawn do
          sleep 1.1.seconds # 1 feels fast, 1.5 feels slow
          btn.icon_name = "edit-copy-symbolic"
          btn.remove_css_class(feedback_class)
          soft_locked = false

          LOGGER.debug { "Copy button feedback reset" }
        end
      end
    end

    Collision::Welcomer.init
    Collision::Compare.init
    Collision::Verify.init

    {% if flag?(:debug) || !flag?(:release) %}
      window.add_css_class("devel")
    {% end %}

    # Adding the controller to the window
    # won't show the border on hover...
    # window.add_controller(Collision::DragNDrop.controller)

    # ... so instead add it to the children,
    # welcomer and fileinfo.
    root.add_controller(Collision::DragNDrop.controller)
    FILE_INFO.add_controller(Collision::DragNDrop.controller)

    window.content = WINDOW_BOX
    window.present

    LOGGER.debug { "Window activated" }
    LOGGER.debug { "Settings: #{window_settings}" }
  end

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

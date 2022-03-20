module Collision
  @@main_window_id = 0_u32

  def activate(app : Adw::Application)
    main_window = APP.window_by_id(@@main_window_id)
    return main_window.present if main_window

    window = Adw::ApplicationWindow.new(app)
    window.name = "mainWindow"
    window.title = Gettext.gettext("Collision")
    window.set_default_size(600, 460)
    window.width_request = 360
    window.height_request = 360
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
      Collision.reset_feedback

      set_file(MAIN_FILE_CHOOSER_NATIVE.file.not_nil!.path.not_nil!)
    end

    OPEN_FILE_BUTTON.clicked_signal.connect do
      MAIN_FILE_CHOOSER_NATIVE.show
    end

    clipboard = window.clipboard
    COPY_BUTTONS.each do |hash_type, btn|
      btn.clicked_signal.connect do
        hash = CLIPBOARD_HASH[hash_type]
        clipboard.set(hash)
      end
    end

    Collision::Welcomer.init
    Collision::Compare.init
    Collision::Verify.init

    {% if flag?(:debug) || !flag?(:release) %}
      window.add_css_class("devel")
    {% end %}

    window.content = WINDOW_BOX
    window.present

    LOGGER.debug { "Window activated" }
  end

  def startup(app : Adw::Application)
    BOTTOM_TABS.notify_signal["reveal"].connect do
      TOOLS_BOX.orientation = BOTTOM_TABS.reveal ? Gtk::Orientation::Vertical : Gtk::Orientation::Horizontal
      TOOLS_BOX.spacing = BOTTOM_TABS.reveal ? 32 : 45
    end

    TOOL_VERIFY_INPUT.remove_css_class("view")
    TOOL_VERIFY_INPUT.cursor_visible = false
    TOOL_VERIFY_INPUT.accepts_tab = false

    scrolled_window = Gtk::ScrolledWindow.new(height_request: 125)
    scrolled_window.child = TOOL_VERIFY_INPUT

    TOOL_VERIFY_OVERLAY.child = scrolled_window
  end

  APP.startup_signal.connect(->startup(Adw::Application))
  APP.activate_signal.connect(->activate(Adw::Application))
  exit(APP.run(ARGV))
end

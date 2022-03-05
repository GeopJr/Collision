module Hashbrown
  @@main_window_id = 0_u32

  def activate(app : Adw::Application)
    main_window = APP.window_by_id(@@main_window_id)
    return main_window.present if main_window

    window = Adw::ApplicationWindow.new(app)
    window.name = "mainWindow"
    window.title = "Hashbrown"
    window.set_default_size(600, 460)
    window.width_request = 360
    window.height_request = 360
    @@main_window_id = window.id

    Hashbrown.generate_headbar
    root = Adw::StatusPage.cast(B_UI["welcomer"])

    WINDOW_BOX.append(HEADERBAR)
    WINDOW_BOX.append(root)

    Hashbrown.about_action(app)
    Hashbrown.hashinfo_action(app, @@main_window_id)

    WELCOMER_FILE_CHOOSER_NATIVE.transient_for = window

    MAIN_FILE_CHOOSER_NATIVE.transient_for = window
    MAIN_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
      next unless response == -3
      Hashbrown.reset_feedback

      set_file(MAIN_FILE_CHOOSER_NATIVE.file.not_nil!.path.not_nil!)
    end

    OPEN_FILE_BUTTON.clicked_signal.connect do
      MAIN_FILE_CHOOSER_NATIVE.show
    end

    TOOL_COMPARE_FILE_CHOOSER_NATIVE.transient_for = window

    clipboard = window.clipboard

    COPY_BUTTONS.each do |hash_type, btn|
      btn.clicked_signal.connect do
        hash = CLIPBOARD_HASH[hash_type]
        clipboard.set(hash)
      end
    end

    Hashbrown::Welcomer.init
    Hashbrown::Compare.init
    Hashbrown::Verify.init

    window.content = WINDOW_BOX
    window.present
  end

  APP.activate_signal.connect(->activate(Adw::Application))
  exit(APP.run(ARGV))
end

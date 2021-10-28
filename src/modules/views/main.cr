module Hashbrown
  def activate(app : Adw::Application)
    window = Adw::ApplicationWindow.new(app)
    window.name = "mainWindow"
    window.title = "Hashbrown"
    window.set_default_size(800, 400)
    window.width_request = 360
    window.height_request = 294

    header = Hashbrown.generate_headbar
    root = Gtk::Widget.cast(B_UI["welcomer"])

    WINDOW_BOX.append(header)
    WINDOW_BOX.append(root)

    Hashbrown.about_action(app)
    Hashbrown.hashinfo_action(app)

    WELCOMER_FILE_CHOOSER_NATIVE.transient_for = window

    MAIN_FILE_CHOOSER_NATIVE.transient_for = window
    MAIN_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
      next unless response == -3
      Hashbrown.reset(true)
      CLIPBOARD_HASH.merge!(generate_hashes(MAIN_FILE_CHOOSER_NATIVE.file.path.not_nil!.to_s, TEXT_FIELDS, COPY_BUTTONS))
    end

    OPEN_FILE_BUTTON.clicked_signal.connect do
      MAIN_FILE_CHOOSER_NATIVE.show
    end

    TOOL_COMPARE_FILE_CHOOSER_NATIVE.transient_for = window
    # TOOL_VERIFY_FILE_CHOOSER_NATIVE.transient_for = window

    clipboard = window.clipboard

    COPY_BUTTONS.each do |btn|
      btn.clicked_signal.connect do
        hash = CLIPBOARD_HASH[btn]
        clipboard.set(hash)
      end
    end

    Hashbrown::Welcomer.init
    # Hashbrown::Verify.init
    Hashbrown::Compare.init
    Hashbrown::Validate.init

    window.content = WINDOW_BOX
    window.present
  end

  APP.activate_signal.connect(->activate(Adw::Application))
  exit(APP.run(ARGV))
end

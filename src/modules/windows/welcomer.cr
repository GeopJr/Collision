module Hashbrown
  welcomeBtn = Gtk::Button.cast(BUILDER["welcomeBtn"])

  mainFileChooser = Gtk::FileChooserNative.cast BUILDER["mainFileChooserNative"]

  viewStack = Gtk::Stack.cast BUILDER["viewStack"]
  titleStack = Gtk::Stack.cast BUILDER["titleStack"]

  welcomeBtn.on_clicked do |btn|
    mainFileChooserResponse = mainFileChooser.run
    if mainFileChooserResponse == -3
      viewStack.visible_child_name = "page1"
      titleStack.visible_child_name = "page1"
      filename = mainFileChooser.filename.not_nil!
      MAIN_FILE.filename = filename
      CLIPBOARD_HASH.merge!(generate_hashes(filename, TEXT_FIELDS, COPY_BUTTONS))
    end
  end
end

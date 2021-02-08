module Hashbrown
  clipboard = Gtk::Clipboard.default(Gdk::Display.default.not_nil!)

  MAIN_FILE.on_file_set do |x|
    Hashbrown.clear(0)
    CLIPBOARD_HASH.merge!(generate_hashes(x.filename.not_nil!, TEXT_FIELDS, COPY_BUTTONS))
  end

  COPY_BUTTONS.each do |btn|
    btn.on_clicked do |_|
      hash = CLIPBOARD_HASH[btn]
      clipboard.set_text(hash, hash.size)
    end
  end

  window = Gtk::Window.cast BUILDER["mainWindow"]
  window.connect "destroy", &->Gtk.main_quit
  window.show_all
end

module Hashbrown
  aboutBtn = Gtk::Button.cast(BUILDER["aboutBtn"])

  aboutDialog = Gtk::Window.cast BUILDER["aboutDialog"]

  # Show the about window when the about button is clicked
  aboutDialog.connect "delete-event", &->aboutDialog.hide
  aboutBtn.on_clicked do |button|
    aboutDialog.show
  end
end

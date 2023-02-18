module Collision
  class Loading
    getter widget : Gtk::Spinner = Gtk::Spinner.new(
      spinning: true,
      halign: Gtk::Align::Center,
      vexpand: true,
      hexpand: true,
      width_request: 32,
      height_request: 32
    )

    def initialize
    end
  end
end

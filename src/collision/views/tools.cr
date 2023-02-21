# The tools sub-view

module Collision::Views
  class Tools
    getter widget : Gtk::Grid
    @tools : Array(Tool) = Array(Tool).new

    def initialize(@hash_list : Widgets::HashList)
      @widget = Gtk::Grid.new(
        row_homogeneous: true,
        row_spacing: 32,
        column_homogeneous: true,
        column_spacing: 45
      )

      [{"Checksum", Collision::Widgets::Tools::Verify}, {"File", Collision::Widgets::Tools::Compare}].each_with_index do |tool_info, i|
        container = generate_tool_container(tool_info)
        @widget.attach(container, i, 0, 1, 1)
      end
    end

    def clear
      @tools.each do |tool|
        tool.clear
      end
    end

    private def generate_tool_container(tool_info : {String, Tool.class}) : Gtk::Box
      res = Gtk::Box.new(
        orientation: Gtk::Orientation::Vertical,
        spacing: 20
      )

      res.append(
        Gtk::Label.new(
          label: Gettext.gettext(tool_info[0]),
          wrap: true,
          wrap_mode: Pango::WrapMode::WordChar,
          justify: Gtk::Justification::Center,
          valign: Gtk::Align::Center,
          vexpand: true,
          css_classes: {
            "title",
            "title-1",
            "compact-title",
          }
        )
      )

      tool = tool_info[1].new(@hash_list)
      @tools << tool
      res.append(
        tool.widget
      )

      res
    end
  end
end

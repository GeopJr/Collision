# The main view.

module Collision::Views
  class Main
    getter widget : Gtk::Box = Gtk::Box.new(Gtk::Orientation::Vertical, 0)
    getter switcher_bar : Adw::ViewSwitcherBar
    getter switcher_title : Adw::ViewSwitcherTitle
    getter file_info : Adw::StatusPage
    getter hash_list : Collision::Widgets::HashList = Collision::Widgets::HashList.new(APP.active_window.not_nil!.clipboard)
    getter file_util : Collision::FileUtil

    @tools : Collision::Views::Tools
    @stack : Adw::ViewStack

    def initialize(@root : Adw::ViewStack)
      @stack = Adw::ViewStack.new(
        vhomogeneous: false,
        hhomogeneous: false
      )

      @tools = Collision::Views::Tools.new(@hash_list)
      @stack.add_titled_with_icon(@hash_list.widget, "hashes", Gettext.gettext("Hash"), "octothorp-symbolic")
      @stack.add_titled_with_icon(@tools.widget, "verify", Gettext.gettext("Verify"), "test-pass-symbolic")

      b_ht = Gtk::Builder.new_from_resource("/dev/geopjr/Collision/ui/switcher.ui")
      @switcher_bar = Adw::ViewSwitcherBar.cast(b_ht["switcher_bar"])
      @switcher_bar.stack = @stack

      tools_grid_first_child = @tools.widget.first_child
      tools_grid_last_child = @tools.widget.last_child
      @switcher_bar.notify_signal["reveal"].connect do
        next if tools_grid_last_child.nil? || tools_grid_first_child.nil?
        row = 0
        column = 1
        if @switcher_bar.reveal
          row = 1
          column = 0
        end

        @tools.widget.remove(tools_grid_last_child)
        @tools.widget.attach(tools_grid_last_child, column, row, 1, 1)
      end

      @switcher_title = Adw::ViewSwitcherTitle.cast(b_ht["switcher_title"])
      @switcher_title.stack = @stack

      clamp = Adw::Clamp.new(
        tightening_threshold: 100,
        child: @stack
      )
      @file_info = Adw::StatusPage.new(
        vexpand: true,
        child: clamp
      )
      @file_util = Collision::FileUtil.new(@hash_list, @file_info, @root)

      @widget.append(@file_info)
      @widget.append(@switcher_bar)

      self.switcher_visible = false
    end

    def switcher_visible=(visible : Bool)
      @switcher_title.view_switcher_enabled = visible
    end

    def switcher_visible?(visible : Bool) : Bool
      @switcher_title.view_switcher_enabled?
    end

    def clear
      @tools.clear
      @stack.visible_child_name = "hashes"
    end
  end
end

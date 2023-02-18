module Collision
  class Main
    getter widget : Gtk::Box = Gtk::Box.new(Gtk::Orientation::Vertical, 0)
    getter switcher_bar : Adw::ViewSwitcherBar
    getter switcher_title : Adw::ViewSwitcherTitle
    getter file_info : Adw::StatusPage
    getter hash_list : Collision::HashList = Collision::HashList.new(APP.active_window.not_nil!.clipboard)
    getter file_util : Collision::FileUtil

    def initialize
      stack = Adw::ViewStack.new(
        vhomogeneous: false,
        hhomogeneous: false
      )

      stack.add_titled_with_icon(@hash_list.widget, "hashes", Gettext.gettext("Hash"), "octothorp-symbolic")
      stack.add_titled_with_icon(TOOLS_GRID, "verify", Gettext.gettext("Verify"), "test-pass-symbolic")

      @switcher_bar = Adw::ViewSwitcherBar.cast(B_HT["switcher_bar"])
      @switcher_bar.stack = stack

      @switcher_title = Adw::ViewSwitcherTitle.cast(B_HT["switcher_title"])
      @switcher_title.stack = stack

      clamp = Adw::Clamp.new(
        tightening_threshold: 100,
        child: stack
      )
      @file_info = Adw::StatusPage.new(
        vexpand: true,
        child: clamp
      )
      @file_util = Collision::FileUtil.new(@hash_list, @file_info)

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
  end
end

module Collision::Widgets
  class ToggleHFDialog < Adw::PreferencesDialog
    @rows = Hash(Symbol, Adw::SwitchRow).new

    def initialize
      super()

      self.can_close = false
      self.title = Gettext.gettext("_Toggle Hash Functions").delete('_') # avoid introducing a second string for non-underlined
      page = Adw::PreferencesPage.new(
        description: Gettext.gettext("Select which hash functions should be calculated.")
      )
      group = Adw::PreferencesGroup.new

      Collision::HASH_FUNCTIONS.each do |k, v|
        row = Adw::SwitchRow.new(title: v)
        row.active = !Collision::Settings.safe_disabled_hash_functions.includes?(k)

        if k == Collision::VERIFICATION_HASH_FUNCTION
          row.sensitive = false
          row.active = true
          row.subtitle = Gettext.gettext("This hash function is used for file verification and cannot be disabled")
        end

        group.add(row)
        @rows[k] = row
      end

      page.add(group)
      self.add(page)

      self.close_attempt_signal.connect(->on_close_attempt)
    end

    def on_close_attempt
      dhf = [] of Symbol
      @rows.each do |k, v|
        dhf << k unless v.active
      end

      # Nothing changed, just close
      if dhf.to_set == Collision::Settings.safe_disabled_hash_functions.to_set
        self.force_close
        return
      end

      if Collision.atomic > 0
        self.add_toast(Adw::Toast.new(Gettext.gettext("Wait for all ongoing operations to finish")))
        return
      end

      @rows.clear
      Collision::Settings.update_disabled_hash_functions(dhf.map &.to_s)
      self.force_close
    end
  end
end

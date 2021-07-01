module Hashbrown
  hashInput = Gtk::Entry.cast(BUILDER["hashInput"])

  verifyBtn = Gtk::Button.cast(BUILDER["verifyBtn"])

  verifyBtn.on_clicked do |btn|
    input = hashInput.buffer.text
    Hashbrown.clear(2)
    tmpHashes = CLIPBOARD_HASH.values.dup
    matches = tmpHashes.reject! { |x| x == input }.size != 3
    if matches
      VERIFY_STATUS.visible_child_name = "page1"
    else
      VERIFY_STATUS.visible_child_name = "page2"
    end
  end
end

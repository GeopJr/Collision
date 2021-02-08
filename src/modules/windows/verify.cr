module Hashbrown
  hashInput = Gtk::Entry.cast(BUILDER["hashInput"])

  verifyBtn = Gtk::Button.cast(BUILDER["verifyBtn"])

  verifyBtn.on_clicked do |btn|
    input = hashInput.buffer.text
    Hashbrown.clear(2)
    tmpHashes = CLIPBOARD_HASH.values.dup
    matches = tmpHashes.reject! { |x| x == input }.size != 3
    if matches
      VERIFY_STATUS.label = "<span foreground=\"#2e2ec2c27e7e\">They match!</span>"
    else
      VERIFY_STATUS.label = "<span foreground=\"#c0c01c1c2828\">They don't match!</span>"
    end
  end
end

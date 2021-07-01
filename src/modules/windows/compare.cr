module Hashbrown
  compareBtn = Gtk::Button.cast(BUILDER["compareBtn"])

  compareFile = Gtk::FileChooserButton.cast(BUILDER["compareFile"])

  compareFilePath = ""

  compareBtn.on_clicked do |btn|
    compareFileMD5 = Hashbrown.run_cmd("md5sum", [compareFilePath]).split(" ")[0]
    if CLIPBOARD_HASH[COPY_BUTTONS[0]] == compareFileMD5
      COMPARE_STATUS.visible_child_name = "page1"
    else
      COMPARE_STATUS.visible_child_name = "page2"
    end
  end

  compareFile.on_file_set do |x|
    compareFilePath = "#{x.filename}"
    Hashbrown.clear(1)
  end
end

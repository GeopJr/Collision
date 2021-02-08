module Hashbrown
  compareBtn = Gtk::Button.cast(BUILDER["compareBtn"])

  compareFile = Gtk::FileChooserButton.cast(BUILDER["compareFile"])

  compareFilePath = ""

  compareBtn.on_clicked do |btn|
    compareFileMD5 = Hashbrown.run_cmd("md5sum", [compareFilePath]).split(" ")[0]
    if CLIPBOARD_HASH[COPY_BUTTONS[0]] == compareFileMD5
      COMPARE_STATUS.label = "<span foreground=\"#2e2ec2c27e7e\">They match!</span>"
    else
      COMPARE_STATUS.label = "<span foreground=\"#c0c01c1c2828\">They don't match!</span>"
    end
  end

  compareFile.on_file_set do |x|
    compareFilePath = "#{x.filename}"
    Hashbrown.clear(1)
  end
end

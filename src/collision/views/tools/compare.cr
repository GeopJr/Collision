module Collision::Compare
  extend self

  MAX_COMPARE_READ_SIZE = 1000000

  def init
    TOOL_COMPARE_BUTTON.clicked_signal.connect do
      TOOL_COMPARE_FILE_CHOOSER_NATIVE.show
    end

    TOOL_COMPARE_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
      next unless response == -3

      Collision::Compare.file = TOOL_COMPARE_FILE_CHOOSER_NATIVE.file.not_nil!
    rescue ex
      LOGGER.debug { ex }
    end
  end

  def file=(file : Gio::File)
    LOGGER.debug { "Begin comparing tool" }
    file_path = file.path.not_nil!
    Collision.file?(file_path)

    TOOL_COMPARE_BUTTON_SPINNER.visible = true
    TOOL_COMPARE_BUTTON_IMAGE.visible = false
    TOOL_COMPARE_BUTTON.remove_css_class("success")
    TOOL_COMPARE_BUTTON.remove_css_class("error")

    TOOL_COMPARE_BUTTON_LABEL.label = file_path.basename.to_s
    Collision::Checksum.spawn do
      compareFileSHA256 = Collision::Checksum.calculate("sha256", file.path.to_s)
      result = CLIPBOARD_HASH["SHA256"] == compareFileSHA256
      result = compare_content(file_path) if !result && File.size(file_path) < MAX_COMPARE_READ_SIZE
      classes = Collision::Feedback.class(result)

      sleep 500.milliseconds
      TOOL_COMPARE_BUTTON_SPINNER.visible = false
      TOOL_COMPARE_BUTTON_IMAGE.visible = true
      TOOL_COMPARE_BUTTON_IMAGE.icon_name = Collision::Feedback.icon(result)
      TOOL_COMPARE_BUTTON.add_css_class(classes[:add])
      TOOL_COMPARE_BUTTON.remove_css_class(classes[:remove])

      LOGGER.debug { "Finished comparing tool" }
    end
  end

  def compare_content(file_path : Path | String) : Bool
    LOGGER.debug { "Begin comparing content" }
    res = false

    File.open(file_path) do |file_io|
      file_io.each_line do |line|
        break res = true if line.split(' ').any? { |word| CLIPBOARD_HASH.values.includes?(word.downcase) }
      end
    end

    LOGGER.debug { "Finished comparing content" }
    res
  end
end

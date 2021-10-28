# Disabled for now

# module Hashbrown
#   module Verify
#     extend self

#     VERIFY_FILTER = Gtk::FileFilter.new(name: "Text")
#     VERIFY_FILTER.add_mime_type("text/*")

#     def init
#       TOOL_VERIFY_BUTTON.clicked_signal.connect do
#         TOOL_VERIFY_FILE_CHOOSER_NATIVE.show
#       end

#       TOOL_VERIFY_FILE_CHOOSER_NATIVE.filter = VERIFY_FILTER

#       TOOL_VERIFY_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
#         next unless response == -3
#         puts TOOL_VERIFY_FILE_CHOOSER_NATIVE.file.path
#         scanned = File.read(TOOL_VERIFY_FILE_CHOOSER_NATIVE.file.path.to_s).downcase.scan(/[a-z0-9]+/)
#         matches = scanned.reject! { |x| !CLIPBOARD_HASH.values.includes?(x[0]?) }

#         puts matches.size > 0
#       end
#     end
#   end
# end

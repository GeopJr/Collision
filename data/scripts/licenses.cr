# Generates a list of licenses of all shards and the app itself
# Inspired by: https://github.com/elorest/compiled_license
# Adapted from sabo-tabby https://github.com/GeopJr/sabo-tabby/blob/main/src/licenses.cr

APP_NAME      = {{read_file("#{__DIR__}/../../shard.yml").split("name: ")[1].split("\n")[0]}}
LICENSE_FILES = {"LICENSE", "LICENSE.md", "LICENSE.txt", "UNLICENSE"}
DIVIDER       = String.build do |str|
  str << "-" * 80
  str << '\n'
end

licenses = [] of String
root = Path[__DIR__, "..", ".."]
lib_folder = root / "lib"

def get_license_content(parent : Path) : String?
  license = nil
  LICENSE_FILES.each do |license_file|
    license_path = parent / license_file
    if File.exists?(license_path)
      license = String.build do |str|
        str << DIVIDER
        str << File.read(license_path)
        str << DIVIDER
      end
      break
    end
  end
  license
end

unless (license = get_license_content(root)).nil?
  licenses << license
end

Dir.each_child(lib_folder) do |shard|
  path = lib_folder / shard
  next if File.file?(path)

  unless (license = get_license_content(path)).nil?
    licenses << "#{shard.capitalize}\n#{license}"
  end
end

licenses.unshift(APP_NAME.capitalize)

puts licenses.join('\n')

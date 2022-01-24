# Generates the required sources for the flatpak based on the shard.lock

require "yaml"
require "json"
require "option_parser"

PATH = Path["lib"]

toJson = false

OptionParser.parse do |parser|
  parser.on "-j", "--json", "Whether it should export json instead of yaml" do
    toJson = true
  end
end

lockfile = YAML.parse(File.read("shard.lock"))

shards = lockfile["shards"]

sources = [] of Hash(String, String)
postinstall_scripts = [] of String

shards.as_h.each do |x, y|
  version_type = "tag"
  version = "v" + y["version"].to_s
  if version.includes?("+git.commit.")
    version_type = "commit"
    version = version.split("+git.commit.")[-1]
  end
  sources << {
    "type"       => "git",
    "url"        => y["git"].to_s,
    version_type => version,
    "dest"       => PATH.join(x.to_s).to_s,
  }
end

Dir.open("lib/").each_child do |child|
  child_path = Path["lib/"].join(child)
  next unless File.directory?(child_path)
  shard_file = YAML.parse(File.read(child_path.join("shard.yml")))
  postinstall = shard_file["scripts"]?.try &.["postinstall"]?
  next unless postinstall
  postinstall_scripts << "cd #{child_path} && #{postinstall} && cd ../.."
end

commands = [] of String

commands << "for i in ./#{PATH}/*/; do ln -snf \"..\" \"$i/lib\"; done"
commands += postinstall_scripts if postinstall_scripts.size > 0

# The following loop will go through all libs and symlink their libs to the parent folder.
puts "Place the following snippet inside the 'build-commands' of your config:"
puts toJson ? commands.to_pretty_json : commands.to_yaml
puts "Keep in mind that postinstall scripts might need to be modified and audited."
puts ""
puts "Place the following snippet inside the 'sources' of your config:"
puts toJson ? sources.to_pretty_json : sources.to_yaml

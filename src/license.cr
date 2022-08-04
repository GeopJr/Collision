module Collision
  LICENSE      = {{run("#{__DIR__}/../data/scripts/licenses.cr").stringify}}
  LICENSE_ARGS = {"--licenses", "--license", "--legal", "--licence", "--licences"}

  if ARGV.size > 0 && LICENSE_ARGS.includes?(ARGV[0].downcase)
    puts LICENSE
    exit 0
  end
end

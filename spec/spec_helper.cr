require "spec"
require "libadwaita"
require "gettext"
require "log"
require "../src/collision/tool.cr"

module Collision
  LOGGER = Log.for("Collision", Log::Severity::None)

  class MockApplication
    def initialize
    end

    def active_window
    end
  end

  APP = MockApplication.new

  enum HashFunction
    MD5
    SHA1
    SHA256
    SHA512
  end

  CLIPBOARD_HASH = {
    "md5"    => "f7e3f382f0382147661c82af20e274e8",
    "sha1"   => "c8f0b71214e8164aa69419b7ac0bcd8a74f529a6",
    "sha256" => "08e3dfc089e66c44ae8abd3476b0f810f11f4cfc2ab925f1607c7df21345d639",
    "sha512" => "2ddb9cca7753a01fcbcdbacc228ae8c314ff4e735c6fffb42286272fb460930dc74f122a9f365053a13016b22403ad4e192142e8668bc5f7d6fce865eb38ec2c",
  }
end

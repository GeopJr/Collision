require "spec"
require "libadwaita"
require "gettext"
require "log"

module Collision
  LOGGER         = Log.for("Collision", Log::Severity::None)
  HASH_FUNCTIONS = {
    md5:     "MD5",
    sha1:    "SHA1",
    sha256:  "SHA256",
    sha512:  "SHA512",
    blake3:  "Blake3",
    crc32:   "CRC32",
    adler32: "Adler32",
  }
  CLIPBOARD_HASH = {
    md5:     "f7e3f382f0382147661c82af20e274e8",
    sha1:    "c8f0b71214e8164aa69419b7ac0bcd8a74f529a6",
    sha256:  "08e3dfc089e66c44ae8abd3476b0f810f11f4cfc2ab925f1607c7df21345d639",
    sha512:  "2ddb9cca7753a01fcbcdbacc228ae8c314ff4e735c6fffb42286272fb460930dc74f122a9f365053a13016b22403ad4e192142e8668bc5f7d6fce865eb38ec2c",
    blake3:  "8a69892f0946333dbf909ecb68866d2f7116b7ba18ee7f2421afd705f9383cfc",
    crc32:   "592339ec",
    adler32: "1ba80397",
  }
end

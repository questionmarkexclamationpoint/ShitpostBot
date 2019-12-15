module Constants
  MESSAGE_SEPARATOR = [0xE000].pack("U*").freeze
  USER_SEPARATOR = [0xE001].pack("U*").freeze
  ENCODING_CHARACTERS = [
    ([0xE002].pack("U*")..[0xF8FF].pack("U*")).freeze,
    ([0xF0000].pack("U*")..[0xFFFFD].pack("U*")).freeze,
    ([0x100000].pack("U*")..[0x10FFFD].pack("U*")).freeze
  ].freeze
end

require "spec"
require "../src/expletive"

SRAND = Random.new(3478)

def random_string(max_len=10)
  l = SRAND.next_int % 255

  bytes = [] of UInt8
  l.times do
    ch = (SRAND.next_int % 255).to_u8
    bytes << ch
  end
  sio = StringIO.new
  sio.write(bytes)
  sio.to_s
end

def endump(input)
  in_io = StringIO.new(input)
  out_io = StringIO.new
  Expletive::Dump.new(in_io, out_io).run
  out_io.to_s
end

def dedump(input)
  in_io = StringIO.new(input)
  out_io = StringIO.new
  Expletive::Undump.new(in_io, out_io).run
  out_io.to_s
end

def round_trip(input)
  dedump(endump(input))
end

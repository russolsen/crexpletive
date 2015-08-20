module Expletive
  SPACE = ' '.ord
  TILDE = '~'.ord
  NEWLINE = '\n'.ord
  BACKSLASH = '\\'.ord

  class Dump
    def initialize(in_io=STDIN, out_io=STDOUT)
      @in = in_io
      @out = out_io
      @current_width = 0
    end

    def run
      n = 0
      while true
        byte = @in.read_byte
        break unless byte
        case 
        when byte ==  BACKSLASH
          write_string "\\\\"
        when byte == NEWLINE
          write_string "\\n"
        when human_readable?(byte)
          write_string byte.chr 
        else
          write_string  "\\%02x" % byte
        end
      end
    end

    def start_new_line
      @out.print("\n")
      @current_width = 0
    end

    def write_string(s)
      @out.print(s)
      @current_width += 1
      start_new_line if @current_width > 60
    end

    def human_readable?(byte)
      (byte >= SPACE) && (byte <= TILDE)
    end
  end

  class Undump
    def initialize(in_io=STDIN, out_io=STDOUT)
      @in = in_io
      @out = out_io
    end

    def run
      while true
        ch = @in.read_char
        break if ch.is_a?(Nil)
        if ch == '\n'
          # do nothing
        elsif ch != '\\'
          @out.print ch
        else
          handle_escape
        end
      end
    end

    def handle_escape
      nextc = @in.read_char
      # puts "Handle escape: #{nextc}"
      raise "Unexpected eof" if nextc.is_a?(Nil)
      case 
      when nextc == '\\'
        @out.print "\\"
      when nextc == 'n'
        @out.print "\n"
      when nextc.in_set?("0123456789abcdef")
        otherc = @in.read_char
        hex = "#{nextc}#{otherc}"
        b = hex.to_u8(16)
        @out.write_byte(b)
      else
        raise "Dont know what to do with \\#{nextc}"
      end
    end
  end
end

module Seafoam
    # An adapter to read binary values from a String unsing unpack and @.
    class StringUnpackBinaryReader
      def initialize(string)
        @string = string
        @n = 0
      end
  
      def read_utf8(length)
        read_bytes(length).force_encoding Encoding::UTF_8
      end
  
      def read_bytes(length)
        unpack("a#{length}", length)
      end
  
      def read_float64
        unpack('G', 8)
      end
  
      def read_float32
        unpack('g', 4)
      end
  
      def read_sint64
        unpack('q>', 8)
      end
  
      def read_sint32
        unpack('l>', 4)
      end
  
      def read_sint16
        unpack('s>', 2)
      end
  
      def read_uint16
        unpack('S>', 2)
      end
  
      def read_sint8
        unpack('c', 1)
      end
  
      def read_uint8
        unpack('C', 1)
      end
  
      def peek_sint8
        unpack_peek('c')
      end
  
      def skip_float64(count = 1)
        skip count * 8
      end
  
      def skip_float32(count = 1)
        skip count * 4
      end
  
      def skip_int64(count = 1)
        skip count * 8
      end
  
      def skip_int32(count = 1)
        skip count * 4
      end
  
      def skip_int16(count = 1)
        skip count * 2
      end
  
      def skip_int8(count = 1)
        skip count
      end
  
      def skip(count)
        @n += count
      end
  
      def eof?
        @n == @string.length
      end

      def unpack(expression, length)
        value = @string.unpack1("@#{@n}#{expression}")
        @n += length
        value
      end

      def unpack_peek(expression)
        @string.unpack1("@#{@n}#{expression}")
      end
    end
  end
  
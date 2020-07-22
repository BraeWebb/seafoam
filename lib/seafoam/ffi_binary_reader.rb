module Seafoam
    # An adapter to read binary values from an FFI pointer.
    class FFIBinaryReader
      def initialize(pointer, length)
        @pointer = pointer.order(:network)
        @length = length
        @n = 0
      end
  
      def read_utf8(length)
        return nil if eof?
        read_bytes(length).force_encoding Encoding::UTF_8
      end
  
      def read_bytes(length)
        return nil if eof?
        value = @pointer.get_string(@n, length)
        @n += length
        value
      end
  
      def read_float64
        return nil if eof?
        value = @pointer.get_float64(@n)
        @n += 8
        value
      end
  
      def read_float32
        return nil if eof?
        value = @pointer.get_float32(@n)
        @n += 4
        value
      end
  
      def read_sint64
        return nil if eof?
        value = @pointer.get_int64(@n)
        @n += 8
        value
      end
  
      def read_sint32
        return nil if eof?
        value = @pointer.get_int32(@n)
        @n += 4
        value
      end
  
      def read_sint16
        return nil if eof?
        value = @pointer.get_int16(@n)
        @n += 2
        value
      end
  
      def read_uint16
        return nil if eof?
        value = @pointer.get_uint16(@n)
        @n += 2
        value
      end
  
      def read_sint8
        return nil if eof?
        value = @pointer.get_int8(@n)
        @n += 1
        value
      end
  
      def read_uint8
        return nil if eof?
        value = @pointer.get_uint8(@n)
        @n += 1
        value
      end
  
      def peek_sint8
        return nil if eof?
        @pointer.get_int8(@n)
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
        @n == @length
      end
    end
  end
  
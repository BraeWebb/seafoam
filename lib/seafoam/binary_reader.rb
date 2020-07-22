require 'stringio'

module Seafoam
  module BinaryReader
    def self.for(source)
      case source
      when File
        IOBinaryReader.new(File.open(source))
      when IO
        IOBinaryReader.new(source)
      when String
        IOBinaryReader.new(StringIO.new(source))
      else
        source
      end
    end
  end
end

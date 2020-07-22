#!/usr/bin/env ruby

require 'ffi'

require 'seafoam'

require 'benchmark/ips'

BGV_FILE = File.expand_path('../examples/matmult-java.bgv', __dir__)
BGV_STRING = File.read(BGV_FILE)

Benchmark.ips do |x|
  x.warmup = 10
  x.time = 10

  x.report('IO-io') do
    File.open(BGV_FILE) do |stream|
      parser = Seafoam::BGVParser.new(Seafoam::IOBinaryReader.new(stream))
      parser.read_file_header
      parser.skip_document_props
      loop do
        index, = parser.read_graph_preheader
        break unless index

        parser.read_graph_header
        parser.read_graph
      end
    end
  end

  x.report('IO-SIO-read') do
    parser = Seafoam::BGVParser.new(Seafoam::IOBinaryReader.new(StringIO.new(File.read(BGV_FILE))))
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      parser.read_graph_header
      parser.read_graph
    end
  end

  x.report('IO-SIO-string') do
    parser = Seafoam::BGVParser.new(Seafoam::IOBinaryReader.new(StringIO.new(BGV_STRING)))
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      parser.read_graph_header
      parser.read_graph
    end
  end

=begin
  x.report('SU-read') do
    parser = Seafoam::BGVParser.new(Seafoam::StringUnpackBinaryReader.new(File.read(BGV_FILE)))
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      parser.read_graph_header
      parser.read_graph
    end
  end

  x.report('SU-string') do
    parser = Seafoam::BGVParser.new(Seafoam::StringUnpackBinaryReader.new(BGV_STRING))
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      parser.read_graph_header
      parser.read_graph
    end
  end
=end

  x.report('FFI-read') do
    string = File.read(BGV_FILE)
    pointer = FFI::MemoryPointer.from_string(string)
    parser = Seafoam::BGVParser.new(Seafoam::FFIBinaryReader.new(pointer, string.bytesize))
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      header = parser.read_graph_header
      parser.read_graph
    end
    pointer.free
  end

  x.report('FFI-string') do
    pointer = FFI::MemoryPointer.from_string(BGV_STRING)
    parser = Seafoam::BGVParser.new(Seafoam::FFIBinaryReader.new(pointer, BGV_STRING.bytesize))
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      parser.read_graph_header
      parser.read_graph
    end
    pointer.free
  end

  x.compare!
end

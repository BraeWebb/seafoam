#!/usr/bin/env ruby

require 'seafoam'

require 'benchmark/ips'

# This benchmark compares throughput of fully reading a graph file, compared
# to, as best as possible, seeking through it.

BGV_FILE = File.expand_path('../examples/matmult-ruby.bgv', __dir__)
stream = File.read(BGV_FILE)

Benchmark.ips do |x|
  x.warmup = 10
  x.time = 10

  x.report('read') do
    parser = Seafoam::BGVParser.new(stream)
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      parser.read_graph_header
      parser.read_graph
    end
  end

  x.report('seek') do
    parser = Seafoam::BGVParser.new(stream)
    parser.read_file_header
    parser.skip_document_props
    loop do
      index, = parser.read_graph_preheader
      break unless index

      parser.skip_graph_header
      parser.skip_graph
    end
  end

  x.compare!
end

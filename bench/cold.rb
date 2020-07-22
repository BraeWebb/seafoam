#!/usr/bin/env ruby

require 'benchmark'

require 'seafoam'

# This benchmark measures how long it takes to read and render a graph to
# GraphViz from cold, as you would in an actual command.

BGV_FILE = File.expand_path('../examples/matmult-ruby.bgv', __dir__)

puts Benchmark.measure {
  parser = Seafoam::BGVParser.new(File.read(BGV_FILE))
  parser.read_file_header
  parser.skip_document_props
  parser.read_graph_preheader
  parser.read_graph_header
  parser.read_graph

  writer = Seafoam::GraphvizWriter.new(File.open('/dev/null', 'w'))
  writer.write_graph graph
}

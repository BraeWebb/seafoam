#!/usr/bin/env ruby

require 'stringio'

require 'seafoam'

require 'benchmark/ips'

# This benchmark measures how long it takes to render a graph to GraphViz.

BGV_FILE = File.expand_path('../examples/matmult-ruby.bgv', __dir__)

parser = Seafoam::BGVParser.new(File.read(BGV_FILE))
parser.read_file_header
parser.skip_document_props
parser.read_graph_preheader
parser.read_graph_header
graph = parser.read_graph

Benchmark.ips do |x|
  x.warmup = 10
  x.time = 10

  x.report('render') do
    out = StringIO.new
    writer = Seafoam::GraphvizWriter.new(out)
    writer.write_graph graph
  end
end

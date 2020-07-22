#!/usr/bin/env ruby

require 'benchmark'

require 'seafoam'

# This benchmark measures the time taken by the external dot Graphviz program
# to render to PDF.

Dir.glob(File.expand_path('../examples/*.bgv', __dir__)).each do |file|
  parser = Seafoam::BGVParser.new(File.read(file))
  parser.read_file_header
  parser.skip_document_props
  loop do
    index, = parser.read_graph_preheader
    break unless index

    parser.read_graph_header
    graph = parser.read_graph

    annotator_options = {
      hide_frame_state: true,
      hide_floating: false,
      reduce_edges: true
    }

    Seafoam::Annotators.apply graph, annotator_options

    File.open('out.dot', 'w') do |dot_stream|
      writer = Seafoam::GraphvizWriter.new(dot_stream)
      writer.write_graph graph
    end

    print "#{file}:#{index} (#{graph.nodes.size} nodes, #{graph.edges.size} edges)... "

    puts Benchmark.measure {
      `dot -Tpdf -o out.pdf out.dot`
    }
  end
end

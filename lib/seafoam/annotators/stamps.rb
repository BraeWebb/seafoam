module Seafoam
    module Annotators
      # Annotate nodes with stamp information
      class StampAnnotator < Annotator
        def self.applies?(_graph)
          true
        end
  
        def annotate(graph)
          if @options[:show_stamps]
            graph.nodes.each_value do |node|
              if node.props[:label] && node.props['stamp']
                node.props[:label] = node.props[:label] + "\n" + node.props['stamp']
              end
            end
          end
        end
      end
    end
  end
  
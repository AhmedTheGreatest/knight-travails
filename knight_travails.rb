# frozen_string_literal: true

module KnightTravails
  # This class represents a Node containing a position in a chess board in a graph
  class MovementNode
    attr_accessor :position, :neighbors

    def initialize(position)
      @position = position
      @neighbors = []
    end

    def add_edge(neighbor)
      @neighbors << neighbor
    end
  end

  # This class represents a Graph of Chess Movement Nodes
  class MovementGraph
    attr_accessor :nodes

    VALID_MOVES = [[1, 2], [-2, -1], [-1, 2], [2, -1],
                   [1, -2], [-2, 1], [-1, -2], [2, 1]].freeze

    def initialize
      @nodes = []
      build_graph
    end

    def build_graph
      @nodes.each do |node|
        x, y = node.position
        VALID_MOVES.each do |transform_x, transform_y|
          new_x = x + transform_x
          new_y = y + transform_y

          neighbor_node = find_node([new_x, new_y]) || add_node([new_x, new_y]) if valid_position?(new_x, new_y)
          node.add_edge(neighbor_node)
        end
      end
    end

    def add_node(position)
      @nodes << MovementNode.new(position)
    end

    private

    def find_node(position)
      @nodes.find { |node| node.position == position }
    end

    def valid_position?(x, y)
      (0..7).cover?(x) && (0..7).cover?(y)
    end
  end
end

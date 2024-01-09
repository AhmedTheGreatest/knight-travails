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
      create_nodes
      connect_nodes
    end

    def create_nodes
      positions_to_create = Set.new
      8.times do |x|
        8.times do |y|
          positions_to_create << [x, y]
        end
      end

      positions_to_create.each do |position|
        add_node(position)
      end
    end

    def connect_nodes
      @nodes.each do |node|
        x, y = node.position
        VALID_MOVES.each do |transform_x, transform_y|
          new_x = x + transform_x
          new_y = y + transform_y

          if valid_position?(new_x, new_y)
            neighbor_node = find_node([new_x, new_y])
            node.add_edge(neighbor_node)
          end
        end
      end
    end

    def knight_moves(start_pos, end_pos)
      start_node = find_node(start_pos)
      end_node = find_node(end_pos)

      return nil unless start_node && end_node

      visited = Set.new
      queue = [[start_node.position]]

      until queue.empty?
        current_path = queue.shift
        current_node = find_node(current_path.last)

        return current_path if current_node == end_node

        current_node.neighbors.each do |neighbor|
          next_path = current_path + [neighbor.position]
          queue << next_path unless visited.include?(neighbor.position)
          visited << neighbor.position
        end
      end

      nil
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

graph = KnightTravails::MovementGraph.new
p graph.knight_moves([3, 3], [4, 3])

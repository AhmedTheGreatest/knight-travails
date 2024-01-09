# frozen_string_literal: true

module KnightTravails
  # This class represents a Node containing a position in a chess board in a graph
  class MovementNode
    attr_accessor :position, :neighbors

    def initialize(position)
      @position = position
      @neighbors = []
    end

    # Creates an edge with a neighbor
    def add_edge(neighbor)
      @neighbors << neighbor
    end
  end

  # This class represents a Graph of Chess Movement Nodes
  class MovementGraph
    attr_accessor :nodes

    # Valid moves for knights
    VALID_MOVES = [[1, 2], [-2, -1], [-1, 2], [2, -1],
                   [1, -2], [-2, 1], [-1, -2], [2, 1]].freeze

    def initialize
      @nodes = []
      build_graph
    end

    # Builds the graph
    def build_graph
      create_nodes
      connect_nodes
    end

    # Creates all the nodes in a chess board
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

    # Connects all the neighbor nodes together
    def connect_nodes
      # Loops over each node and creates edges with their neighbors
      @nodes.each do |node|
        x, y = node.position
        # Loops over every valid move transformation for a Knight
        VALID_MOVES.each do |transform_x, transform_y|
          # Calculates the new coordinates
          new_x = x + transform_x
          new_y = y + transform_y

          next unless valid_position?(new_x, new_y) # If the move is invalid jump to the next iteration

          neighbor_node = find_node([new_x, new_y]) # Finds the neighbor node from the coordinates
          node.add_edge(neighbor_node) # Creates an edge
        end
      end
    end

    # Finds the shortest path from start_pos to end_pos using Breadth-First Search
    def knight_moves(start_pos, end_pos)
      # Finds the nodes from their position
      start_node = find_node(start_pos)
      end_node = find_node(end_pos)

      return nil unless start_node && end_node # If the nodes cannot be found return nil

      visited = Set.new # This set will contain all the nodes that we have visited
      queue = [[start_node.position]] # A queue which will contain the paths

      # Until the queue is empty
      until queue.empty?
        # Gets the current path
        current_path = queue.shift
        # Finds the current node
        current_node = find_node(current_path.last)

        # Returns the path if we have successfuly found the end_node
        return current_path if current_node == end_node

        # Adds the current node's neighbors to the queue
        current_node.neighbors.each do |neighbor|
          next_path = current_path + [neighbor.position]
          queue << next_path unless visited.include?(neighbor.position)
          visited << neighbor.position
        end
      end

      nil
    end

    # Adds a node to the graph
    def add_node(position)
      @nodes << MovementNode.new(position)
    end

    private

    # Finds a node from the graph
    def find_node(position)
      @nodes.find { |node| node.position == position }
    end

    # Returns true if a position is valid in a chess board
    def valid_position?(x, y)
      (0..7).cover?(x) && (0..7).cover?(y)
    end
  end
end

graph = KnightTravails::MovementGraph.new
p graph.knight_moves([3, 3], [4, 3])

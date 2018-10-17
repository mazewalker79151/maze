require "colorize"
class Solver # uni implementation using dijkstra algo
  attr_reader :table_merged, :table_reversed, :x, :start_node, :goal_node, :backtrack, :node_list, :nodes, :path, :path_steps
  attr_accessor :table

  def initialize(table)
    @table = table
    @table_reversed = @table.reverse

    @table_merged = []
    @table_convert = []
    @start_node = 999
    @exit_node = 999
    @current_node = 999
    @x = @table_reversed[0].size
    @y = @table_reversed.size
    @unvisited_list = []
    @node_list = []
    @path = []
    @path_steps = []
    @backtrack = []
    process_maze
    create_node_list
    dijkstra
  end # initialize

  def process_maze
    x = 0
    y = 0
    z = 0 # will be used as a node number to correlate later
    @table_reversed.each do |row|
      row.each do |item|
        @start_node = z if item == "S"

        # create a simple array with all values
        @table_merged << item
        @table_convert << [item, [x, y]]
        y += 1
        z += 1
      end
      x += 1
      y = 0
    end

    # store nodes in an array from 0 to sizeX*sizeY counting left to right and top to bottom
    @nodes = [*0...@table.flatten.length]

    # create an initial list of unvisited nodes without walls
    @unvisited_list = @nodes.map { |r| r if @table_merged[r] != "x" }
    @unvisited_list.delete(nil)
    @unvisited_list
  end # parse_maze


  # initialize node structure
  def create_node_list
    previous_node = nil
    @current_node = @start_node

    unvisited_list = @unvisited_list.dup

    while unvisited_list.size > 0 do # while there are unvisited nodes

      @current_node = unvisited_list.shift
      @exit_node = @current_node if @table_merged[@current_node] == "E" # success?

      @current_node == @start_node ? @distance = 0 : @distance = 1 # default distance 1

      @node_list << {
        id: @current_node,
        neighbours: check_edges(@current_node), # get node neigbours
        dist: @distance,
        prev: previous_node
      }
    end
  end # create nodes


  # check neighbours for edges
  def get_all_neighbours(node)
    return {
	:top => node + @x,
	:bottom => node - @x,
	:left => node -1,
	:right => node + 1
    }
  end # get_all_neighbours


  def check_edges(node)
    neighbours = []
    possible_neighbours = get_all_neighbours(node)

    # check If neighbours are not in the edges
    neighbours << possible_neighbours[:left] if possible_neighbours[:left] > 0 && node % @x != 0 && @table_merged[ possible_neighbours[:left] ] != "x"
    neighbours << possible_neighbours[:top] if possible_neighbours[:top] < (@x * @y) && @table_merged[ possible_neighbours[:top] ] != "x"
    neighbours << possible_neighbours[:bottom] if possible_neighbours[:bottom] - @x >= 0 && @table_merged[ possible_neighbours[:bottom] ] != "x"
    neighbours << possible_neighbours[:right] if (node + 1) % @x != 0 && @table_merged[ possible_neighbours[:right] ] != "x"
    return neighbours
  end # check_edges


  def dijkstra
    unvisited_list = @unvisited_list.dup

    # create a queue for nodes to check
    @queue = []
    current_node = @start_node
    @queue << current_node

    # stop when nothing left to visit
    while unvisited_list.size > 0 && @queue.size > 0 do

      # visit current node
      current_node = @queue.shift
      unvisited_list.delete(current_node)

      # find the current node's neighbours and add them to the queue
      rolling_node = @node_list.find { |hash| hash[:id] == current_node }
      rolling_node[:neighbours].each do |p|
        # only add them if they are unvisited and they are not in the queue
        if unvisited_list.index(p) && !@queue.include?(p)
          @queue << p
          # set prev node as current
          change_node = @node_list.find { |hash| hash[:id] == p }
          change_node[:prev] = current_node
          # increase distance of visited nodes
          change_node[:dist] = rolling_node[:dist] + 1
        end
      end

      if current_node == @exit_node
        get_shortest_path(rolling_node)
        break
      end
    end
    return @path_steps
  end # dijkstra algo


  def get_shortest_path(rolling_node)
    @backtrack = []
    @backtrack << @exit_node

    # iterate until start node
    while rolling_node[:prev] != nil do
      temp_node = @node_list.find { |hash| hash[:id] == rolling_node[:prev] }
      @backtrack << temp_node[:id]
      rolling_node = temp_node
    end

    @path = []
    @backtrack.each do |p|
      @path << [p, @table_convert[p]]
      @path_steps << @table_convert[p][1]
    end
  end # get_shortest_path


  def get_solution
    results = Array.new(@table.size){ Array.new(@table.first.size, false) }
    (@table.size-1).downto(0).each do |row_index|
        row = @table[row_index]
        row.each_with_index do |col, col_index|
            el = @table.reverse[row_index][col_index]
            if @path_steps.include?( [ row_index, col_index ] ) && !["S", "E"].include?(el)
                results[row_index][col_index] = "P"
            else
                results[row_index][col_index] = el
            end
        end

    end
    results.reverse
  end # get_solution


  def to_s
    buf = ""
    get_solution.each do |row|
        row.each do |el|
          if ["S","P"].include?(el)
              buf << el.green
          else
              buf << el
          end
        end # col/el/node
        buf << "\r\n"
    end # row
    buf
  end # visualize

end # Solver

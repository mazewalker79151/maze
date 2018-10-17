require "colorize"

class Hypermaze # copied from https://github.com/sethm/ruby_maze + support for 3D maze
  attr_accessor :maze

  DIRECTIONS = [ [0, -1, 0], [0, 1, 0 ], [0, 0, -1], [0, 0, 1 ], [-1, 0, 0 ], [1, 0, 0] ] # [plane, row, col]

  def initialize(rows, cols, planes = 1)
    @rows = rows
    @cols = cols
    @planes = planes

    @maze = Array.new(@planes) do |p|
      Array.new(@rows) do |r|
        Array.new(@cols) do |c|
    	    Node.new(r, c, p) # empty node
        end
      end
    end # planes

    # start and end nodes on first/last plane on opposite ends
    @start_node = @maze[0][rand(@rows)][0]
    @end_node = @maze[@planes-1][rand(@rows)][@cols - 1]
  end # initialize


  def generate
    stack = [] # store nodes here

    node = @start_node
    node.visited = true
    stack.push(node)

    while true
      next_node = get_next_unvisited(node)
      if next_node
        next_node.visited = true
        next_node.connect_to(node)
        stack.push(next_node)
        node = next_node
      else
        node = stack.pop
        break if !node
      end
    end
  end # generate


  def solve
      # reset state
       @maze.each do |plane|
    	    plane.each do |row|
          		row.each do |node|
          		    node.visited = false
          		end
        	end
       end # @maze

      stack = []

      node = @start_node
      node.visited = true
      node.on_path = true

      while true
        next_node = get_next_in_graph(node)

        if next_node
          next_node.visited = true
          next_node.on_path = true

          break if next_node == @end_node # done?

          stack.push(node) # keep going...
          node = next_node
        else
          break if stack.size == 0 # no solution
          # no un-visited neighbors => remove from path
          node.on_path = false
          node = stack.pop
        end
      end
  end # solve


  def get_next_in_graph(node)
    node.neighbors.values.compact.shuffle.select {|neighbor| !neighbor.visited }.first
  end # get_next_in_graph


  def get_next_unvisited(node)
    neighbors = []
    DIRECTIONS.each do |dir|
      new_plane = node.plane + dir[0]
      new_row = node.row + dir[1]
      new_col = node.col + dir[2]
      if new_plane >= 0 && new_plane < @planes && new_row >= 0 && new_row < @rows && new_col >= 0 && new_col < @cols && !@maze[new_plane][new_row][new_col].visited
        neighbors << @maze[new_plane][new_row][new_col]
      end
    end

    neighbors[rand(neighbors.length)]
  end # get_next_unvisited


  def to_s
    buf = ""
  	@maze.each_with_index do |plane, plane_idx|
  	    buf << "Plane #{plane_idx}\r\n"
  	    plane.each_with_index do |row, idx|
    	      row.each do |node|
    	        buf << if node.neighbors[:north]
    	                 "+   "
    	               else
    	                 "+---"
    	               end

    	        buf << if node.col == @cols - 1
    	                 "+"
    	               else
    	                 ""
    	               end
    	      end # row
    	      buf << "\r\n"

    	      row.each do |node|
    	        buf << if node.neighbors[:west] || node == @start_node
        	    		       if node == @start_node
        	                "S".red
      	                 else
      	        	        " "
        	               end
    	               else
    	                 "|"
    	               end

    	        buf << if node.on_path
          	    		    if node.neighbors[:top]
            	    			  " U ".light_blue
          	    		    elsif node.neighbors[:bottom]
          	    			    " D ".yellow
          	    		    else
          	              " P ".green
          	    		    end
    	               else
    	                 "   "
    	               end

    	        if node.col == @cols - 1
    	          buf << if node == @end_node
    	                   "E".green
    	                 else
    	                   "|"
    	                 end
    	        end
    	      end # row
    	      buf << "\r\n"

    	      # last row
    	      if idx == @rows - 1
    	        row.each do |node|
    	          buf << "+---"
    	        end
    	        buf << "+\r\n"
    	      end
  	    end # row
  	end # plane
    buf
  end # to_s
end # hypermaze

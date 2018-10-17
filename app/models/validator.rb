require "matrix"

class Validator # highschool recursive algo, non-optimal solution
  attr_reader :is_valid, :final_path

  def initialize(table, max_iterations = 10000)
      @navigation_limit_iterations = max_iterations
      @navigation_counter = 0
      @table = table
      @validation_path = Array.new(@table.size){ Array.new(@table.first.size, false) }

      @final_path = @visited = Array.new(@table.size){ Array.new(@table.first.size, false) }
      @start_col, @start_row = Matrix[ *@table ].index("S")

      @is_valid = self.navigate_recursive(@start_col, @start_row)
  end # initialize

  def navigate_recursive(col,row)
      @navigation_counter+=1
      return false if @navigation_counter > @navigation_limit_iterations
      return false if col < 0 || row < 0 || row > @table.first.size-1 || col > @table.size-1    	# out of bounds
      return true if @table[col][row] == "E"                                                    	# success
      return false if @table[col][row] == "x" || @table[col][row] == "C"                        	# wall or current cell
      @validation_path[col][row] = true
      @table[col][row] = "C"
      return true if self.navigate_recursive( col, row-1 )                                    	# go forward
      return true if self.navigate_recursive( col-1, row )                                    	# go backward
      return true if self.navigate_recursive( col, row+1 )                                    	# go left
      return true if self.navigate_recursive( col+1, row )                                    	# go right
      # TODO adapt to move up/down on 3d maze
      @validation_path[col][row] = false
      @table[col][row] = "."
      return false
  end # navigate_recursive

end

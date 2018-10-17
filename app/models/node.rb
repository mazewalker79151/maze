class Node
  attr_accessor :row, :col, :plane, :visited, :neighbors, :on_path, :maze

  def initialize(row, col, plane = 0)
    @row = row
    @col = col
    @plane = plane
    @visited = false
    @on_path = false
    @neighbors = {north: nil, east: nil, south: nil, west: nil, above: nil, below: nil}
  end # initialize

  # connect to other nodes
  def connect_to(other)
    if other.row == self.row - 1 # bottom
      self.neighbors[:north] = other
      other.neighbors[:south] = self
    elsif other.row == self.row + 1 # top
      self.neighbors[:south] = other
      other.neighbors[:north] = self
    elsif other.col == self.col + 1 # right
      self.neighbors[:east] = other
      other.neighbors[:west] = self
    elsif other.col == self.col - 1 # left
      self.neighbors[:west] = other
      other.neighbors[:east] = self
    elsif other.plane == self.plane - 1 # below
      self.neighbors[:bottom] = other
      other.neighbors[:top] = self
    elsif other.plane == self.plane + 1 # above
      self.neighbors[:top] = other
      other.neighbors[:bottom] = self
    end
  end # connect_to

  def coords
    [ @plane, @row, @col ]
  end # coords
end # node

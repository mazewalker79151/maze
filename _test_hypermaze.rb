#!/usr/bin/env ruby

require_relative "app/models/node"
require_relative "app/models/hypermaze"

rows = ARGV[0].to_i
cols = ARGV[1].to_i
planes = ARGV[2].to_i

if rows <= 0 || cols <= 0 || planes <= 0
  puts "Usage: #{$0} <rows> <cols> <planes>"
  exit -1
end

maze = Hypermaze.new(rows, cols, planes)
maze.generate
puts "Maze:"
puts maze

maze.solve
puts "\n\nSolution (P = path, D = going down, U = going up, S = start, E = end)"
puts maze

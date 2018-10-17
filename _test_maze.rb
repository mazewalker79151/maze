#!/usr/local/bin/ruby

require_relative "app/models/solver.rb"
require_relative "app/models/validator.rb"
require "matrix"

@raw_data = File.read("./example_mazes/maze6.txt").split("\n").collect{ |row| row.split("") }
check = Validator.new(@raw_data)
if check.is_valid
    puts "Valid maze!"
    maze = Solver.new(File.read("./example_mazes/maze6.txt").split("\n").collect{ |row| row.split("") } )
    puts maze # colorized for your viewing pleasure
else
    puts "Invalid maze!"
end

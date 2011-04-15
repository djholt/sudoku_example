#!/usr/bin/ruby

require 'sudoku'

unless ARGV.first
  puts "USAGE: ./solve.rb file"
  exit
end

s = Sudoku.new
s.import_problem ARGV.first
s.print_problem

puts "Solving..."

if solution = s.solve!
  solution.print_problem
else
  puts "No solution found"
end

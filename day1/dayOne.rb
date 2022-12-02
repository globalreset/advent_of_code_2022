#!/bin/env ruby

inputList = IO.readlines("day1/dayOneInput.txt").map(&:chomp)

elfTable = []
while (idx = inputList.index(""))
   elfTable << inputList.shift(idx)
   inputList.shift
end
elfTable << inputList

elfSums = elfTable.map { |i| i.map(&:to_i).inject(:+) }.sort

puts elfSums[-1]
puts elfSums[-3..-1].inject(:+)
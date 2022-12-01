inputList = IO.readlines("day1/dayOneInput.txt").map(&:chomp)

elfTable = []
while (idx = inputList.index(""))
   elfTable << inputList.shift(idx).map{|i| i.to_i}
   inputList.shift
end
elfTable << inputList.map{|i| i.to_i }

elfSums = elfTable.map { |i| i.inject(:+) }.sort

puts elfSums[-1]
puts elfSums[-3..-1].inject(:+)
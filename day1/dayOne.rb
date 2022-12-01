inputList = IO.readlines("day1/dayOneInput.txt")

elf = 0
caloriesPerElf = []
inputList.size.times { |i|
   if(inputList[i].chomp=="")
      elf += 1
   else
      caloriesPerElf[elf] = (caloriesPerElf[elf] || 0) + inputList[i].to_i
   end
}

puts caloriesPerElf.max

puts caloriesPerElf.sort[-3..-1].inject(:+)
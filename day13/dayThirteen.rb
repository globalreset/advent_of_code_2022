inputList = IO.readlines("day13/dayThirteenInput.txt").map(&:chomp)

left = []
right = []
while(inputList.size>0)
   left << (eval inputList.shift)
   right << (eval inputList.shift)
   inputList.shift 
end

def comparePair(left, right)
   if(left==nil || right==nil)
      if(left==nil)
         return -1 
      else
         return 1
      end
   elsif(left.is_a?(Integer) && right.is_a?(Integer))
      return left <=> right
   elsif(left.is_a?(Array) && right.is_a?(Array))
      minLen = [left.size,right.size].min
      (0...minLen).each { |i|
         result = comparePair(left[i], right[i])
         return result if(result!=0)
      }
      return left.size<=>right.size
   elsif(left.is_a?(Array) && right.is_a?(Integer))
      return comparePair(left, [right])
   elsif(right.is_a?(Array) && left.is_a?(Integer))
      return comparePair([left], right)
   else
      puts "unhandled case: #{left} vs #{right}"
   end
end

indexSum = 0
left.zip(right).each_with_index { |pair, index|
   if(comparePair(pair[0], pair[1])==-1)
      indexSum += index + 1
   end
}
puts indexSum


div = [ [[2]], [[6]] ]
all = [left, right, div].flatten(1)
sorted = all.sort(&method(:comparePair))
puts div.map { |d| sorted.find_index(d) + 1}.inject(1, &:*)
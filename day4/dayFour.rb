inputList = IO.readlines("day4/dayFourInput.txt").map(&:chomp)

range = []
inputList.each { |i|
   pair = []
   i.split(",").each { |j|
      j = j.split("-").map(&:to_i)
      pair << (j[0]..j[1]).to_a
   }
   range << pair
}

overlapCnt = 0
range.each { |pair|
   i = pair[0] & pair[1] 
   if(i==pair[0] || i==pair[1])
      overlapCnt += 1
   end
}

p overlapCnt

overlapCnt = 0
range.each { |pair|
   i = pair[0] & pair[1] 
   if(i.size>0)
      overlapCnt += 1
   end
}

p overlapCnt
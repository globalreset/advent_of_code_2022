inputList = IO.readlines("day10/dayTenInput.txt").map(&:chomp)

adds = [1]
inputList.each { |line|
   adds << 0
   if(line=~ /addx (.*)/)
      adds << Regexp.last_match(1).to_i
   end
}

strengthSum = 0
[20,60,100,140,180,220].each { |i|
   strengthSum += (adds[0...i].sum*i)
}
puts strengthSum

crtRow = [""]
sum = adds[0]
(1...adds.size).each { |cycle|
   if(((sum-1)..(sum+1)).to_a.include?((cycle-1)%40))
      crtRow[-1] += "#"
   else
      crtRow[-1] += "."
   end
   if(cycle%40==0)
      crtRow << ""
   end
   sum += adds[cycle]
}
puts crtRow.join("\n")



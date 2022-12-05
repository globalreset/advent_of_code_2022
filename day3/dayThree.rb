inputList = IO.readlines("day3/dayThreeInput.txt").map(&:chomp)
inputList = inputList.map{ |i| i.split('') }

def getPrio(i)
   if(i<'a'.ord)
      27 + i - 'A'.ord
   else
      1 + i - 'a'.ord
   end
end

common = []
inputList.each { |i|
   r1,r2 = i.each_slice(i.size/2).to_a
   common << (r1 & r2)[0]
}

p common.map(&:ord).map{ |i| getPrio(i) }.sum

badges = []
inputList.each_slice(3) { |triplet|
   badges << (triplet[0] & triplet[1] & triplet[2])[0]
}

p badges.map(&:ord).map { |i| getPrio(i) }.sum
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
   r1 = i[0...(i.size/2)]
   r2 = i[(i.size/2)..-1]

   r1.each { |j|
      if(r2.index(j))
         common << j
         break
      end
   }
}

prio = common.map(&:ord).map{ |i| getPrio(i) }
p prio.sum

badges = []
inputList.each_slice(3) { |triplet|
   badges << (triplet[0] & triplet[1] & triplet[2])[0]
}

prio = badges.map(&:ord).map { |i| getPrio(i) }
p prio.sum
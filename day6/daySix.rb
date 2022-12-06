inputList = IO.readlines("day6/daySixInput.txt").map(&:chomp)

input = inputList[0].split('')

require "set"

input.each_cons(4).to_a.each_with_index { |quad, idx|
   if(quad.to_set.size==4)
      puts idx+4
      break
   end
}

input.each_cons(14).to_a.each_with_index { |quad, idx|
   if(quad.to_set.size==14)
      puts idx+14
      break
   end
}
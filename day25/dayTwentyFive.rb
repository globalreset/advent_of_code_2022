inputList = IO.readlines("day25/dayTwentyFiveInput.txt").map(&:chomp)

DIGITS = { '2'=>2, '1'=>1, "0"=>0, "-"=>-1, "="=>-2 }

sum = inputList.map { |l|
   l.split("").reverse.map.with_index { |c,i|
      DIGITS[c]*(5**i)
   }.sum
}.sum

snafu = []
while(sum > 0)
   sum, remainder = sum.divmod(5)
   if(remainder<3)
      snafu.insert(0, remainder.to_s)
   else
      sum += 1 # have to borrow from next power
      if(remainder<4)
         snafu.insert(0, "=")
      else
         snafu.insert(0, "-")
      end
   end
end
puts snafu.join

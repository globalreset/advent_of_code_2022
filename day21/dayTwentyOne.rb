input = IO.readlines("day21/dayTwentyOneInput.txt").map(&:chomp).map { |i|
   i = i.split(": ")
   if(i[1]=~/^-?\d+$/)
      i[1] = i[1].to_i 
   else
      i[1] = i[1].split(" ")
   end
   [i[0], i[1]]
}.to_h

def getEqn(input, key)
   i = input[key]
   if(i.is_a? Integer)
      return i
   elsif(i.is_a? String)
      return i
   else
      return ["(", getEqn(input, i[0]), i[1], getEqn(input, i[2]), ")"]
   end
end

puts eval getEqn(input, "root").join(" ")

input["humn"] = "humn"
target = eval getEqn(input, input["root"][2]).join("")
eqn = getEqn(input, input["root"][0])

v = target
while(eqn.is_a? Array)
   arg1 = eqn[1]
   op = eqn[2]
   arg2 = eqn[3]
   arg1 = eval(arg1.join) if(arg1.is_a?(Array) && !arg1.join.include?("humn"))
   arg2 = eval(arg2.join) if(arg2.is_a?(Array) && !arg2.join.include?("humn"))
   if(op=="*")
      if(arg2.is_a? Integer)
         v = v / arg2
         eqn = arg1
      else
         v = v / arg1
         eqn = arg2
      end
   elsif(op=="/")
      if(arg2.is_a? Integer)
         v = v * arg2
         eqn = arg1
      else
         throw "error: humn is demoninator"
      end
   elsif(op=="+")
      if(arg2.is_a? Integer)
         v = v - arg2
         eqn = arg1
      else
         v = v - arg1
         eqn = arg2
      end
   elsif(op=="-")
      if(arg2.is_a? Integer)
         v = v + arg2
         eqn = arg1
      else
         v = arg1 - v
         eqn = arg2
      end
   end
end
puts v
exit

# through experimentation, I found the range of human was somewhere between
# 3700000000000 and 3800000000000. So I did a binary search which found an
# answer pretty quick... Only problem, it was one answer but not *the* answer
#puts (eval (equation.gsub(/humn/, "3782852515587"))) == target
#puts (eval (equation.gsub(/humn/, "3782852515583"))) == target
#
#puts target
#puts eval (equation.gsub(/humn/, "3700000000000"))
#puts eval (equation.gsub(/humn/, "3700000000001"))
#puts eval (equation.gsub(/humn/, "3800000000000"))
#n1 = 3700000000000
#n2 = 3800000000000
#ans = 0
#while(true)
#   mid = n1 + (n2 - n1)/2
#   puts "(#{n2} - #{n1})/2 = #{mid}"
#   (ans = eval equation.gsub(/humn/, mid.to_s)) 
#   puts "#{ans}==#{target}==#{ans==target}"
#   if(ans==target)
#      puts mid
#   elsif(ans<target)
#      n2 = mid - 1
#   else
#      n1 = mid + 1
#   end
#end
#puts target

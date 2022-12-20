inputList = IO.readlines("day20/dayTwentyInput.txt").map(&:chomp)

# have to use an object with index to uniquify the value
# otherwise can't distinguish repeat numbers in the list
Holder = Struct.new(:index, :value)
input = inputList.map(&:to_i).map.with_index{|v,i|Holder.new(i, v)}

S = input.size

def mix (input, rounds)
   mixed = input.dup
   rounds.times {
      input.each {|o|
         if(o.value != 0)
            i = mixed.find_index(o)
            n = (i + o.value - 1) % (S - 1) + 1
            mixed.delete_at(i)
            mixed.insert(n, o)
         end
      }
   }
   mixed
end

m = mix(input, 1)
i = m.find_index{|h| h.value==0 }
puts [1000,2000,3000].map { |n| m[(i + n) % S].value }.sum

input = input.map{ |h| h.value = h.value * 811589153; h }
m = mix(input, 10)
i = m.find_index{|h| h.value==0 }
puts [1000,2000,3000].map { |n| m[(i + n) % S].value }.sum
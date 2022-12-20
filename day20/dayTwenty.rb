Holder = Struct.new(:index, :value) # object with index to uniquify the value
input = IO.readlines("day20/dayTwentyInput.txt").map.with_index{ |v,i| Holder.new(i, v.chomp.to_i)}
S = input.size

def mix (input, rounds)
   mixed = input.dup
   rounds.times {
      input.each {|o|
         i = mixed.find_index(o)
         n = (i + o.value) % (S - 1)
         mixed.insert(n, mixed.delete_at(i))
      }
   }
   return mixed
end

m = mix(input, 1)
i = m.find_index{|h| h.value==0 }
puts [1000,2000,3000].map { |n| m[(i + n) % S].value }.sum

input = input.map{ |h| h.value = h.value * 811589153; h }
m = mix(input, 10)
i = m.find_index{|h| h.value==0 }
puts [1000,2000,3000].map { |n| m[(i + n) % S].value }.sum
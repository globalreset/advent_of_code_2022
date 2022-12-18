inputList = IO.readlines("day17/daySeventeenInput.txt").map(&:chomp)

inputStr = <<EOF
>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
EOF
inputList2 = inputStr.split("\n")

input = inputList.join("").split("")

require_relative '../util/util.rb'

rockTypes = [
   [0b0011110],
   [0b0001000,
    0b0011100,
    0b0001000],
   [0b0000100,
    0b0000100,
    0b0011100],
   [0b0010000,
    0b0010000,
    0b0010000,
    0b0010000],
   [0b0011000,
    0b0011000]
]

initialState = rockTypes.flatten.map(&:to_s).join("")+input.join("")
grid = []
sizeNuked = 0
lastSealed = 0
previousSum = {} 
previousRockTypes = {} 
previousInput = {} 
i = 0
firstSeal = true
#2022.times { |i| 
#1000000000000.times { |i| 
while(i<1000000000000)
#while(i<2022)
   
   # wait 10k records to stabilize and let's look for sealed points
   if(i>100_000 && grid.size>2 && (grid[-2]|grid[-1])==0b111_1111 && 
      (firstSeal || input[0..32].join("")=="<<<>>><<<>><>>><<<<>><<><<<<>>><>"))
      firstSeal = false
      # can't find one row that blocks the whole rest of grid, so
      # what about 2 rows
      sum = grid[0..-3].sum
      if(previousSum[grid.size]==sum && 
         previousRockTypes[grid.size]==rockTypes && 
         previousInput[grid.size]==input)
         #Simulate all the rocks
         #period is 1725
         cheatAmount = (1000000000000 - i)/1725
         sizeNuked += cheatAmount*(grid.size-2)
         i += cheatAmount*1725
         previousSum = {}
      end
      previousSum[grid.size] = sum
      previousRockTypes[grid.size] = rockTypes
      previousInput[grid.size] = input
      sizeNuked += grid.size - 2
      grid = grid[-2..-1]
   end
   rock = rockTypes.shift
   rockTypes.push rock
   rock = rock.reverse
   pos = grid.size + 3
   resting = false
   while(!resting)
      dir = input.shift
      input.push dir
      if(dir=="<")
         # check if can't shift left due to wall
         if(!rock.any?{|r| r&0b100_0000==0b100_0000})
            #check if can't shift left due to pieces
            shiftClear = true
            rock.each_with_index {|r,i| 
               r <<= 1
               shiftClear = shiftClear && (((grid[pos+i]||0)+r)&r == r)
            }
            if(shiftClear)
               rock = rock.map{|r| r<<1 }
            end
         end
      else #dir==">"
         # check if can't shift right due to wall
         if(!rock.any?{|r| r&0b000_0001==0b000_0001})
            #check if can't shift right due to pieces
            shiftClear = true
            rock.each_with_index {|r,i| 
               r >>= 1
               shiftClear = shiftClear && (((grid[pos+i]||0)+r)&r == r)
            }
            if(shiftClear)
               rock = rock.map{|r| r>>1 }
            end
         end
      end
      # check for falling
      fallClear = true
      rock.each_with_index { |r,i| 
         fallClear = fallClear && (((grid[pos-1+i]||0)+r)&r == r)
      }
      if(fallClear && pos>0)
         pos -= 1
      else
         resting = true
         rock.each_with_index { |r,i| 
            grid[pos+i] = (grid[pos+i]||0) + r
         }
      end
   end
   i += 1
   puts grid.size if(i==2022)
end
#}
puts sizeNuked + grid.size
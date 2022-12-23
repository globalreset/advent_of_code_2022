require_relative "../util/util.rb"

inputList = IO.readlines("day22/dayTwentyTwoInput.txt").map(&:chomp)

inputStr = <<EOF
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
EOF

inputList2 = inputStr.split("\n")

gridX = Grid.new
gridY = Grid.new
instructions = inputList[-1].scan(/\d+|R|L/).flatten

start = nil
inputList.each_with_index { |l, y|
   l.split("").each_with_index { |v, x|
      if(v =~ /(#|\.)/)
         start = [x,y] unless(start)
         gridX[x,y] = v
         gridY[y,x] = v
      end
   }      
}

facingTable = {:right => 0, :down => 1, :left => 2, :up => 3}

facing = :right
x,y = start

instructions.each_with_index{ |i,idx|
   if(i=~/\d+/)
      i = i.to_i
      i.times { 
         case(facing)
         when :right 
            r = gridY.grid[y]
            if(x+1 > r.keys.max && r[r.keys.min]==".")

               x = r.keys.min
            elsif (r[x+1]==".")
               x += 1
            end
         when :left
            r = gridY.grid[y]
            if(x-1 < r.keys.min && r[r.keys.max]==".")
               x = r.keys.max
            elsif (r[x-1]==".")
               x -= 1
            end
         when :down
            c = gridX.grid[x]
            if(y+1 > c.keys.max && c[c.keys.min]==".")
               y = c.keys.min
            elsif (c[y+1]==".")
               y += 1
            end
         when :up
            c = gridX.grid[x]
            if(y-1 < c.keys.min && c[c.keys.max]==".")
               y = c.keys.max
            elsif (c[y-1]==".")
               y -= 1
            end
         end
      }
   else
      v = facingTable.keys.find_index(facing)
      if(i=="L")
         v = (v-1) % 4
      else
         v = (v+1) % 4
      end
      facing = facingTable.keys[v]
   end
}

puts 1000*(y+1) + 4*(x+1) + facingTable[facing]

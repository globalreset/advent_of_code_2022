require_relative "../util/util.rb"

inputList = IO.readlines("day22/dayTwentyTwoInput.txt").map(&:chomp)

$gridX = Grid.new
$gridY = Grid.new
$instructions = inputList[-1].scan(/\d+|R|L/).flatten

start = nil
inputList.each_with_index { |l, y|
   l.split("").each_with_index { |v, x|
      if(v =~ /(#|\.)/)
         start = [x,y] unless(start)
         $gridX[x,y] = v
         $gridY[y,x] = v
      end
   }      
}

$facingTable = {:right => 0, :down => 1, :left => 2, :up => 3}

$ranges = {}
$ranges["A"] = { "x" => 50..99,   "y" => 0..49}
$ranges["B"] = { "x" => 100..149, "y" => 0..49}
$ranges["C"] = { "x" => 50..99,   "y" => 50..99}
$ranges["D"] = { "x" => 0..49,    "y" => 100..149}
$ranges["E"] = { "x" => 50..99,   "y" => 100..149}
$ranges["F"] = { "x" => 0..49,    "y" => 150..199}

$faceHash = {}
 200.times { |y|
   150.times { |x|
      $ranges.keys.each { |k|
         if($ranges[k].values.zip([x,y]).map{|r,p| r.cover?(p)}.all?)
            $faceHash[[x,y]] = k
         end
      }
   }
}

def getNewPos(facing, ox, oy, nx, ny)
   newFacing = facing
   newX = nx
   newY = ny
   of = $faceHash[[ox,oy]]
   nf = $faceHash[[nx,ny]]

   dX = nx - $ranges[of]["x"].min
   dXr = $ranges[of]["x"].max - nx
   dY = ny - $ranges[of]["y"].min
   dYr = $ranges[of]["y"].max - ny
   if(of!=nf)
      case (of+facing.to_s)
      # - - - - - - - A - - - - - - -  
      when "Aright" # do nothing
      when "Adown" # do nothing
      when "Aleft" # move to D
         #[50,25] -> [49,20] = [0,129]
         newFacing = :right
         newX = $ranges["D"]["x"].min
         newY = $ranges["D"]["y"].min + dYr
      when "Aup" # move to F
         #[50,25] -> [49,20] = [0,129]
         newFacing = :right
         newX = $ranges["F"]["x"].min
         newY = $ranges["F"]["y"].min + dX
      # - - - - - - - - - - - - - - -  
      # - - - - - - - B - - - - - - -  
      when "Bright" # move to E
         newFacing = :left
         newX = $ranges["E"]["x"].max
         newY = $ranges["E"]["y"].min + dYr
      when "Bdown" # move to C
         newFacing = :left
         newX = $ranges["C"]["x"].max
         newY = $ranges["C"]["y"].min + dX
      when "Bleft" # do nothing
      when "Bup" # move to F
         newFacing = :up
         newX = $ranges["F"]["x"].min + dX
         newY = $ranges["F"]["y"].max
      # - - - - - - - - - - - - - - -  
      # - - - - - - - C - - - - - - -  
      when "Cright" # move to B
         newFacing = :up
         newX = $ranges["B"]["x"].min + dY
         newY = $ranges["B"]["y"].max
      when "Cdown" # do nothing
      when "Cleft" # move to D
         newFacing = :down
         newX = $ranges["D"]["x"].min  + dY
         newY = $ranges["D"]["y"].min
      when "Cup" # do nothing 
      # - - - - - - - - - - - - - - -  
      # - - - - - - - D - - - - - - -  
      when "Dright" # do nothing
      when "Ddown" # do nothing
      when "Dleft" # move to A
         newFacing = :right
         newX = $ranges["A"]["x"].min 
         newY = $ranges["A"]["y"].min + dYr
      when "Dup" # move to C
         newFacing = :right
         newX = $ranges["C"]["x"].min 
         newY = $ranges["C"]["y"].min + dX
      # - - - - - - - - - - - - - - -  
      # - - - - - - - E - - - - - - -  
      when "Eright" # move to B
         newFacing = :left
         newX = $ranges["B"]["x"].max
         newY = $ranges["B"]["y"].min + dYr
      when "Edown" # move to F
         newFacing = :left
         newX = $ranges["F"]["x"].max
         newY = $ranges["F"]["y"].min + dX
      when "Eleft" # do nothing
      when "Eup" # do nothing 
      # - - - - - - - - - - - - - - -  
      # - - - - - - - F - - - - - - -  
      when "Fright" # move to E
         newFacing = :up
         newX = $ranges["E"]["x"].min + dY
         newY = $ranges["E"]["y"].max
      when "Fdown" # move to B
         newFacing = :down
         newX = $ranges["B"]["x"].min + dX
         newY = $ranges["B"]["y"].min
      when "Fleft" # move to A
         newFacing = :down
         newX = $ranges["A"]["x"].min  + dY
         newY = $ranges["A"]["y"].min
      when "Fup" # do nothing 
      # - - - - - - - - - - - - - - -  
      end

   end
   return newFacing, newX, newY
end

def executeInstructions_part1(facing, x, y)
   $instructions.each_with_index{ |i,idx|
      if(i=~/\d+/)
         i = i.to_i
         i.times { 
            case(facing)
            when :right 
               r = $gridY.grid[y]
               if(x+1 > r.keys.max && r[r.keys.min]==".")
                  x = r.keys.min
               elsif (r[x+1]==".")
                  x += 1
               end
            when :left
               r = $gridY.grid[y]
               if(x-1 < r.keys.min && r[r.keys.max]==".")
                  x = r.keys.max
               elsif (r[x-1]==".")
                  x -= 1
               end
            when :down
               c = $gridX.grid[x]
               if(y+1 > c.keys.max && c[c.keys.min]==".")
                  y = c.keys.min
               elsif (c[y+1]==".")
                  y += 1
               end
            when :up
               c = $gridX.grid[x]
               if(y-1 < c.keys.min && c[c.keys.max]==".")
                  y = c.keys.max
               elsif (c[y-1]==".")
                  y -= 1
               end
            end
         }
      else
         v = $facingTable.keys.find_index(facing)
         if(i=="L")
            v = (v-1) % 4
         else
            v = (v+1) % 4
         end
         facing = $facingTable.keys[v]
      end
   }
   return facing, x, y
end

def executeInstructions_part2(facing, x, y)
   $instructions.each_with_index{ |i,idx|
      #puts "Before #{i}, dirIndex=#{$facingTable.keys.find_index(facing)}, x=#{x+1}, y=#{y+1}"
      if(i=~/\d+/)
         i = i.to_i
         i.times { 
            newX, newY = x, y
            case(facing)
            when :right 
               newX += 1
            when :left
               newX -= 1
            when :down
               newY += 1
            when :up
               newY -= 1
            end
            newFacing, newX, newY = getNewPos(facing, x, y, newX, newY)
            if($gridX[newX,newY] == ".")
               facing, x, y = newFacing, newX, newY
            end
         }
      else
         v = $facingTable.keys.find_index(facing)
         if(i=="L")
            v = (v-1) % 4
         else
            v = (v+1) % 4
         end
         facing = $facingTable.keys[v]
      end
   }
   return facing, x, y
end

facing, x, y = executeInstructions_part1(:right, start[0], start[1])

puts 1000*(y+1) + 4*(x+1) + $facingTable[facing]

facing, x, y = executeInstructions_part2(:right, start[0], start[1])

puts 1000*(y+1) + 4*(x+1) + $facingTable[facing]


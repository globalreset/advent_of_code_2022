inputList = IO.readlines("day14/dayFourteenInput.txt").map(&:chomp)

paths = inputList.map { |path|
   path.split(" -> ").map{ |p| p.split(",").map(&:to_i) }
}

def fallingSand(x,y,grid,maxDepth,restAtMax)
   loop do
      if(grid[x,y]!=nil)
         return false # occupied
      elsif(y==maxDepth)
         if(restAtMax)
            grid[x,y] = "o" #bottom of part 2
            return true
         else
            return false #too far for part 1
         end
      elsif(grid[x,y+1]==nil)
         y += 1
      elsif(grid[x-1,y+1]==nil)
         x -= 1
         y += 1
      elsif(grid[x+1,y+1]==nil)
         x += 1
         y += 1
      else
         grid[x,y] = "o"
         return true
      end
   end
end

require_relative "../util/util.rb"

grid1 = Grid.new
paths.each { |path|
   path.each_cons(2) { |p1, p2|
      grid1.setPoints(grid1.getLine(p1[0], p1[1], p2[0], p2[1]), "#")
   }
}

maxDepth = grid1.getYRange.max + 1
count = 0
while(fallingSand(500,0,grid1,maxDepth,false))
   count += 1 
end
puts "Part 1: #{count}"

grid2 = Grid.new
paths.each { |path|
   path.each_cons(2) { |p1, p2|
      grid2.setPoints(grid2.getLine(p1[0], p1[1], p2[0], p2[1]), "#")
   }
}

maxDepth = grid2.getYRange.max + 1
count = 0
while(fallingSand(500,0,grid2,maxDepth,true))
   count += 1 
end
puts "Part 2: #{count}"

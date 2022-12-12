inputList = IO.readlines("day12/dayTwelveInput.txt").map(&:chomp)

grid = inputList.map{ |line|
   line.split('')
}

startPoint = []
endPoint = []
grid.size.times { |i|
   grid[i].size.times { |j|
      if(grid[i][j]=="S")
         grid[i][j] = "a"
         startPoint = [i,j]
      elsif(grid[i][j]=="E")
         grid[i][j] = "z"
         endPoint = [i,j]
      end
   }
}


require 'set'
def findPathBFS(src, dst, grid)
   shortestCost = 1/0.0
   visited = Set.new
   queue = [[src,0]]

   while(queue.size>0)
      src, cost = queue.shift
      if(src==dst)
         shortestCost = cost if(shortestCost>cost)
      elsif(!visited.include?(src))
         visited.add src
         srcLetter = grid[src[0]][src[1]]
         [ [src[0]-1, src[1]], [src[0]+1, src[1]],
           [src[0], src[1]-1], [src[0], src[1]+1]  ].each { |maybe|
            if(maybe[0]>=0 && maybe[1]>=0 &&
               maybe[0]<grid.size && maybe[1]<grid[maybe[0]].size)
               dstLetter = grid[maybe[0]][maybe[1]]
               if(((srcLetter.ord+1)>=dstLetter.ord))
                  queue.push([maybe, cost + 1])
               end
            end
         }
      end
   end
   return shortestCost
end

puts findPathBFS(startPoint, endPoint, grid)
lowPoints = []
grid.size.times { |i|
   grid[i].size.times { |j|
      if(grid[i][j]=="a")
         lowPoints << [i,j]
      end
   }
}
pathCosts = []
lowPoints.each{ |lowPoint|
   pathCosts << findPathBFS(lowPoint, endPoint, grid)
}
puts pathCosts.min

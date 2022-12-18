inputList = IO.readlines("day18/dayEighteenInput.txt").map(&:chomp)

require_relative '../util/util.rb'
require "set"

points = inputList.map{|l| Point3D.new(*l.split(",").map(&:to_i))}

def getNeighbors(p)
   neighbors = []
   [-1,1].each { |delta| 
      neighbors << Point3D.new(p.x+delta,p.y,p.z) 
      neighbors << Point3D.new(p.x,p.y+delta,p.z) 
      neighbors << Point3D.new(p.x,p.y,p.z+delta) 
   }
   return neighbors
end

pointSet = points.to_set
missing = Set.new
exposedFace = 0
pointSet.each { |p|
   getNeighbors(p).each {|n|
      if(!pointSet.include?(n))
         exposedFace += 1
         missing << n
      end
   }
}
puts exposedFace


xVals = points.map{|p| p.x}
yVals = points.map{|p| p.y}
zVals = points.map{|p| p.z}
xR = xVals.min..xVals.max
yR = yVals.min..yVals.max
zR = zVals.min..zVals.max

# do a bfs of every missing node to see if it is interior or exterior
# if it's interior, fill it in. And repeat until no more missing. Then
# all exposed surfaces are exterior
missing.each { |m|
   if(!pointSet.include?(m))
      visited = Set[m]
      queue = [m]
      interior = true

      while(interior && queue.size>0)
         curr = queue.shift
         getNeighbors(curr).each { |n|
            #if it's outside the min/max range, we know it's exterior
            if(xR.cover?(n.x) && yR.cover?(n.y) && zR.cover?(n.z))
               if(!pointSet.include?(n) && !visited.include?(n))
                  visited << n
                  queue.push n
               end
            else
               interior = false
            end
         }
      end
      #if it is interior, combine every node we visited into our
      #known points list
      pointSet = pointSet + visited if(interior)
   end
}

exposedFace = 0
pointSet.each { |p|
   getNeighbors(p).each {|n|
      if(!pointSet.include?(n))
         exposedFace += 1
      end
   }
}
puts exposedFace

inputList = IO.readlines("day9/dayNineInput.txt").map(&:chomp)

def getPerimeter(ptr)
   [[0,0],
    [1,0],[-1,0],
    [0,1],[0,-1],
    [1,-1],[-1,1],
    [1,1],[-1,-1]].map { |dir|
      [ptr[0] + dir[0], ptr[1] + dir[1]]
    }
end

def getDiagonalPerimeter(ptr)
   [[1,-1],[-1,1],
    [1,1],[-1,-1]].map { |dir|
      [ptr[0] + dir[0], ptr[1] + dir[1]]
    }
end

def getNewTail(head, tail)
   headPerim = getPerimeter(head)
   if(headPerim.include?(tail))
      return tail
   elsif(head[0]==tail[0])
      if(head[1]>tail[1])
         return [tail[0], tail[1]+1]
      else
         return [tail[0], tail[1]-1]
      end
   elsif(head[1]==tail[1])
      if(head[0]>tail[0])
         return [tail[0]+1, tail[1]]
      else              
         return [tail[0]-1, tail[1]]
      end
   else
      return (headPerim & getDiagonalPerimeter(tail))[0]
   end
end

head = [0,0]
tail = [0,0]
tailVisited = {}
tailVisited[tail] = true

inputList.each { |line|
   dir,qty = line.split(" ")
   qty.to_i.times { |i|
      if(dir=="R")
         head[0] += 1
      elsif(dir=="L")
         head[0] -= 1
      elsif(dir=="U")
         head[1] += 1
      elsif(dir=="D")
         head[1] -= 1
      end
      tail = getNewTail(head,tail)
      tailVisited[tail] = true
   }
}

p tailVisited.keys.size


ptrs = Array.new(10) { [0,0] }
tailVisited = {}

inputList.each { |line|
   dir,qty = line.split(" ")
   qty.to_i.times { |i|
      if(dir=="R")
         ptrs[0][0] += 1
      elsif(dir=="L")
         ptrs[0][0] -= 1
      elsif(dir=="U")
         ptrs[0][1] += 1
      elsif(dir=="D")
         ptrs[0][1] -= 1
      end
      (0...ptrs.size).each_cons(2) { |i,j|
         ptrs[j] = getNewTail(ptrs[i], ptrs[j])
      }
      tailVisited[ptrs[-1]] = true
   }
}

p tailVisited.keys.size

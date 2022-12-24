require_relative "../util/util.rb"
require 'set'

inputList = IO.readlines("day24/dayTwentyFourInput.txt").map(&:chomp)

$walls = Set.new
$blizzardByType = {}
inputList.each_with_index{ |r,y|
    r.split("").each_with_index{ |v,x|
        if(["<",">"].include?(v))
            ($blizzardByType[y.to_s + v] ||= []) << x
        end
        if(["^","v"].include?(v))
            ($blizzardByType[x.to_s + v] ||= []) << y
        end
        if(v=="#")
           $walls << [x,y] 
        end
    }
}

#internal width and height
$iw = inputList[0].size - 2
$ih = inputList.size - 2

# all blizzards are split up into their row/col and their type.
# so hash stores the x value for all <> blizzards indexed by row
# and the y value for all ^v blizzards indexed by column.
# now the check for any position is simply "get the relevant
# blizzards for that row and column, shift them by the amount of
# time that has passed, and check whether or not they collide"
def checkPos(pos, minutes)
    if($blizzardByType["#{pos[1]}<>#{minutes}"]==nil)
       # get row left
       xLt = ($blizzardByType[pos[1].to_s + "<"]||[]).map { |x| 1 + (x - 1 - minutes) % $iw }
       # get row right
       xRt = ($blizzardByType[pos[1].to_s + ">"]||[]).map { |x| 1 + (x - 1 + minutes) % $iw }
       $blizzardByType["#{pos[1]}<>#{minutes}"] = Set.new(xLt + xRt)
    end
    xVals = $blizzardByType["#{pos[1]}<>#{minutes}"]

    if($blizzardByType["#{pos[0]}^v#{minutes}"]==nil)
       # get column up
       yUp = ($blizzardByType[pos[0].to_s + "^"]||[]).map { |y| 1 + (y - 1 - minutes) % $ih }
       # get column down
       yDn = ($blizzardByType[pos[0].to_s + "v"]||[]).map { |y| 1 + (y - 1 + minutes) % $ih }
       $blizzardByType["#{pos[0]}^v#{minutes}"] = Set.new(yUp + yDn)
    end
    yVals = $blizzardByType["#{pos[0]}^v#{minutes}"]

    return !xVals.include?(pos[0]) && !yVals.include?(pos[1])
end

xVals = $walls.map(&:first)
yVals = $walls.map(&:last)
XR = xVals.min..xVals.max
YR = xVals.min..xVals.max

State = Struct.new(:pos, :minutes)

def timeToGoal(start, goal, currMinutes)
   startState = State.new(start, currMinutes)
   queue = [startState]
   visited = Set.new
   while(queue.size > 0)
      curr = queue.shift
      if(!visited.include?(curr))
           visited << curr
           if(curr.pos == goal)
               return curr.minutes
           else
               [[0,0],[0,1],[0,-1],[-1,0],[1,0]].each {|dir|
                  newPos = [curr.pos[0]+dir[0], curr.pos[1]+dir[1]]
                  if(checkPos(newPos, curr.minutes + 1) && !$walls.include?(newPos) && XR.cover?(newPos[0]) && YR.cover?(newPos[1]))
                      queue << State.new(newPos, curr.minutes + 1)
                  end
               }
           end
       end
   end
   return nil # no path found
end

startPos = [inputList.first.split("").find_index("."), 0]
goalPos  = [inputList.last.split("").find_index("."), $walls.map(&:last).max]

minutes = timeToGoal(startPos, goalPos, 0)
puts minutes
minutes = timeToGoal(goalPos, startPos, minutes)
minutes = timeToGoal(startPos, goalPos, minutes)
puts minutes
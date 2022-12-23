inputList = IO.readlines("day23/dayTwentyThreeInput.txt").map(&:chomp)

Elf = Struct.new(:id, :curr, :next)
elves = []
grid = {}

cnt = 0
inputList.each_with_index{ |r,y|
    r.split("").each_with_index{ |e,x|
        if(e=="#")
            #elves << Elf.new(('A'.ord + cnt).chr, [x,y], [x,y])
            elves << Elf.new("#", [x,y], [x,y])
            grid[[x,y]] = elves[-1]
            cnt += 1
        end
    }
}

DIRECTIONS = [:north, :south, :west, :east]

def getNewCoord(grid, c)
    x,y = c
    occupancy = 
       [[-1,-1],[ 0,-1],[ 1,-1], #NW,N,NE - 0,1,2
        [-1, 0],    nil,[ 1, 0], #W,nil,E - 3,4,5
        [-1, 1],[ 0, 1],[ 1, 1], #SW,S,SE - 6,7,8
       ].map{ |dir|
          grid[[x+dir[0], y+dir[1]]] if(dir)
       }
    #if they are all empty, do nothing
    if(occupancy.any?{|p| p!=nil}) 
        DIRECTIONS.each {|dir|
            case(dir)
            when :north
                return [x+0, y-1] if(occupancy[0..2].all?{|p|p==nil})
            when :south
                return [x+0, y+1] if(occupancy[6..8].all?{|p|p==nil})
            when :west
                return [x-1, y+0] if(occupancy[0]==nil && occupancy[3]==nil && occupancy[6]==nil)
            when :east
                return [x+1, y+0] if(occupancy[2]==nil && occupancy[5]==nil && occupancy[8]==nil)
            end
        }
    end
    return [x,y]
end

def simulateElves(elves,grid)
    elvesMoved = 0
    newElfCnt = {}
    newElfCnt.default = 0
    # figure out direction
    elves.each { |e|
        e.next = getNewCoord(grid, e.curr)
        newElfCnt[e.next] += 1
        p e if (e.id=="A")
    }
    # check for collision
    elves.each{ |e|
        e.next = e.curr if(newElfCnt[e.next]>1)
    }
    # move elf
    elves.each{ |e|
        if(e.next!=e.curr)
           grid[e.curr] = nil
           e.curr = e.next
           grid[e.curr] = e
           elvesMoved += 1
        end
    }
    DIRECTIONS.push(DIRECTIONS.shift)
    return elvesMoved
end

10.times { |round|
    simulateElves(elves,grid)
}

xVals = grid.keys.map(&:first)
yVals = grid.keys.map(&:last)

puts (xVals.min..xVals.max).size * (yVals.min..yVals.max).size - elves.size

rounds = 10
done = false
until(done)
    rounds += 1
    done = (simulateElves(elves,grid)==0)
end
puts rounds
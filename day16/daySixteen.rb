inputList = IO.readlines("day16/daySixteenInput.txt").map(&:chomp)

require_relative '../util/util.rb'
require 'set'

Valve = Struct.new(:name,:rate,:next,:nextOpen,:state)
valves = {}
valveMask = 1
inputList.each { |line|
  l = line.scan(/Valve (.*) has flow rate=(\d+);.*valve[s]? (.*)/).shift
  mask = nil
  valve = Valve.new(l[0], l[1].to_i, l[2].split(", "), {}, false)
  valves[valve.name] = valve
}
valves.values.each { |v| v.next = v.next.map{|n|valves[n]} }

positiveValves = valves.values.map { |v| v.name if(v.rate>0) }.compact

def findPathBFS(src, dst)
   shortestCost = 1/0.0
   visited = Set.new
   queue = [[src,0]]

   while(queue.size>0)
      src, cost = queue.shift
      if(src==dst)
         shortestCost = cost if(shortestCost>cost)
      elsif(!visited.include?(src))
         visited.add src
         src.next.each{ |n|
            queue.push([n, cost + 1])
         }
      end
   end
   return shortestCost
end

#precompute distances from "AA" and every node to every node with flow rate>0
cachedSteps = {}
positiveValves.each { |dst|
   s = valves["AA"]
   d = valves[dst]
   s.nextOpen[dst] = findPathBFS(s,d) + 1
}
(positiveValves.size-1).times { |i|
   src = positiveValves[i]
   positiveValves[(i+1)..-1].each { |dst|
      s = valves[src]
      d = valves[dst]
      s.nextOpen[dst] = findPathBFS(s,d) + 1
      # should be the same, but just in case
      d.nextOpen[src] = findPathBFS(d,s) + 1
   }
}

# do a BFS of the possible solution space
ValveOpen = Struct.new(:current, :minutes, :released, :opened)
best = 0
start = valves["AA"]
queue = [ValveOpen.new(start, 30, 0, Set.new)]
while(queue.size>0)
   state = queue.shift
   noValvesLeft = true
   # from this current valve look at every possible next valve
   state.current.nextOpen.each { |dst,cost|
      # if it's reachable and we haven't opened it
      if(state.minutes - cost > 0 && !state.opened.include?(dst))
         opened = state.opened.dup
         opened.add(dst)
         released = (state.minutes - cost) * valves[dst].rate
         noValvesLeft = false
         queue.push(ValveOpen.new(valves[dst], state.minutes - cost,
                             state.released + released, opened))
      end
   }
   if(noValvesLeft && state.released > best)
      best = state.released 
   end
end
puts best

# for part 2, do a BFS of the solution space but track 2 positions
# on each step of the search
ValveOpen2 = Struct.new(:curr1, :min1, :curr2, :min2, :released, :opened)
best = 0
start = valves["AA"]
state = ValveOpen2.new(start, 26, start, 26, 0, Set.new)
# us a priority queue so it becomes dijkstra's
queue = PQueue.new([state]) {|a,b| a.released<=>b.released }
#queue = [ValveOpen2.new(start, 26, start, 26, 0, Set.new)]
while(queue.size()>0)
   state = queue.pop
   noValvesLeft = true
   # move the one that has more time to catch up
   move1 = (state.min1 >= state.min2)
   curr = move1 ? state.curr1 : state.curr2
   mins = move1 ? state.min1 : state.min2
   curr.nextOpen.each { |dst,cost|
      if(mins - cost > 0 && !state.opened.include?(dst))
         opened = state.opened.dup
         opened.add(dst)
         noValvesLeft = false
         released = (mins - cost) * valves[dst].rate
         if(move1)
            queue.push(ValveOpen2.new(
               valves[dst], state.min1 - cost,
               state.curr2, state.min2,
               state.released + released, opened))
         else
            queue.push(ValveOpen2.new(
               state.curr1, state.min1,
               valves[dst], state.min2 - cost,
               state.released + released, opened))
         end
      end
   }
   if(noValvesLeft && state.released > best)
      best = state.released 
      #takes 24m to complete, so cheating and looking at the most
      #recent stable value and trying it
      puts " -- #{best}"
   end
end
puts best
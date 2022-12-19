inputList = IO.readlines("day19/dayNineteenInput.txt").map(&:chomp)

require_relative '../util/util.rb'
require "set"

inputStr = <<EOF
Blueprint 1: Each ore robot costs 4 ore.  Each clay robot costs 2 ore.  Each obsidian robot costs 3 ore and 14 clay.  Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore.  Each clay robot costs 3 ore.  Each obsidian robot costs 3 ore and 8 clay.  Each geode robot costs 3 ore and 12 obsidian.
EOF
inputList2 = inputStr.split("\n")

Blueprint = Struct.new(:id, :oreBotOre, :clayBotOre, 
                       :obsBotOre, :obsBotClay, 
                       :geodeBotOre, :geodeBotObs)
blueprints = inputList.map{ |line| Blueprint.new(*line.scan(/(\d+)/).flatten.map(&:to_i)) }

BotState = Struct.new(:minutes, 
   :oreBotCnt, :clayBotCnt, :obsBotCnt, :geodeBotCnt, 
   :ore, :clay, :obs, :geode)

def getBestGeodes(bp, minutes)
   #p bp
   best = 0
   queue = [BotState.new(minutes, 1, 0, 0, 0, 0, 0, 0, 0)]
   visited = Set.new
   while(queue.size > 0)
      curr = queue.shift
      if(!visited.include?(curr))
         visited << curr
         if(curr.minutes==0)
            if(best < curr.geode)
               #puts "found new best #{bp.id}: #{curr.geode}"
               best = curr.geode
            end
         elsif(curr.geode + ((1..curr.minutes).to_a.sum) > best)
         #elsif(curr.minutes > 20 || curr.geode + ((1...curr.minutes).to_a.sum) > best)
         #else
            n = BotState.new(
               curr.minutes - 1,
               curr.oreBotCnt,
               curr.clayBotCnt,
               curr.obsBotCnt,
               curr.geodeBotCnt,
               curr.ore + curr.oreBotCnt,
               curr.clay + curr.clayBotCnt,
               curr.obs + curr.obsBotCnt,
               curr.geode + curr.geodeBotCnt
            )
           
            canBuildGeodeBot = (curr.ore>=bp.geodeBotOre && curr.obs>=bp.geodeBotObs)
            canBuildObsBot = !canBuildGeodeBot && 
               (curr.obsBotCnt<bp.geodeBotObs) &&
               (curr.ore>=bp.obsBotOre && curr.clay>=bp.obsBotClay)
            canBuildClayBot = !canBuildGeodeBot && !canBuildObsBot &&
               #don't need nore clay than 1 obsBot per min
               (curr.clayBotCnt<bp.obsBotClay) && 
               (curr.ore>=bp.clayBotOre)
            canBuildOreBot = !canBuildGeodeBot && !canBuildObsBot &&
               (curr.oreBotCnt<[bp.geodeBotOre,bp.obsBotOre,bp.clayBotOre].max) &&
               (curr.ore>=bp.oreBotOre)
            # don't want to hoard unnecessarily
            canBuildNothing = !canBuildGeodeBot &&
               (curr.ore < 2*[bp.geodeBotOre,bp.obsBotOre,bp.clayBotOre].max) &&
               (curr.clay < 3*bp.obsBotClay)

            # push build nothing state only if we aren't overhoarding ore
            queue << n if(canBuildNothing)

               # push build geode bot state
            queue << BotState.new(
               n.minutes,
               n.oreBotCnt, 
               n.clayBotCnt,
               n.obsBotCnt, 
               n.geodeBotCnt + 1,
               n.ore - bp.geodeBotOre, 
               n.clay,
               n.obs - bp.geodeBotObs,
               n.geode
            ) if(canBuildGeodeBot)

            # push build obs bot state
            queue << BotState.new(
               n.minutes,
               n.oreBotCnt, 
               n.clayBotCnt,
               n.obsBotCnt + 1, 
               n.geodeBotCnt,
               n.ore - bp.obsBotOre,
               n.clay - bp.obsBotClay,
               n.obs,
               n.geode
            ) if(canBuildObsBot)
            
            # push build clay bot state
            queue << BotState.new(
               n.minutes,
               n.oreBotCnt, 
               n.clayBotCnt + 1,
               n.obsBotCnt, 
               n.geodeBotCnt,
               n.ore - bp.clayBotOre,
               n.clay,
               n.obs,
               n.geode
            ) if(canBuildClayBot)
            
            # push build ore bot state
            queue << BotState.new(
               n.minutes,
               n.oreBotCnt + 1, 
               n.clayBotCnt,
               n.obsBotCnt, 
               n.geodeBotCnt,
               n.ore - bp.oreBotOre,
               n.clay,
               n.obs,
               n.geode
            ) if(canBuildOreBot)
         end
      end
   end
   #puts "best: #{best}"
   return best
end

puts blueprints.map { |bp|
   getBestGeodes(bp, 24) * bp.id
}.sum

puts blueprints[0..2].map { |bp|
   getBestGeodes(bp, 32)
}.inject(1,:*)

inputList = IO.readlines("day19/dayNineteenInput.txt").map(&:chomp)

require "set"

Blueprint = Struct.new(:id, :oreBotOre, :clayBotOre, 
                       :obsBotOre, :obsBotClay, 
                       :geodeBotOre, :geodeBotObs)
blueprints = inputList.map{ |line| Blueprint.new(*line.scan(/(\d+)/).flatten.map(&:to_i)) }

BotState = Struct.new(:minutes, 
   :oreBotCnt, :clayBotCnt, :obsBotCnt, :geodeBotCnt, 
   :ore, :clay, :obs, :geode)

def getBestGeodes(bp, minutes)
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
         # abandon thread if there is no way we could beat the current best
         #elsif(curr.geode + ((1..curr.minutes).to_a.sum) > best)
         #elsif(curr.minutes > 20 || curr.geode + ((1...curr.minutes).to_a.sum) > best)
         else
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
           
            # always build geode bot if you can 
            canBuildGeodeBot = (curr.ore>=bp.geodeBotOre && curr.obs>=bp.geodeBotObs)
            # don't build obs bot if you can build geode bot
            canBuildObsBot = !canBuildGeodeBot && 
               #don't need more obs than 1 geodeBot per min
               (curr.obsBotCnt<bp.geodeBotObs) &&
               (curr.ore>=bp.obsBotOre && curr.clay>=bp.obsBotClay)
            # don't build clay bot if you can build geode bot
            canBuildClayBot = !canBuildGeodeBot && !canBuildObsBot &&
               #don't need more clay than 1 obsBot per min
               (curr.clayBotCnt<bp.obsBotClay) && 
               (curr.ore>=bp.clayBotOre)
            canBuildOreBot = !canBuildGeodeBot && !canBuildObsBot &&
               #don't need more ore than the max any bot could need per min
               (curr.oreBotCnt<[bp.geodeBotOre,bp.obsBotOre,bp.clayBotOre].max) &&
               (curr.ore>=bp.oreBotOre)
            # don't want to hoard if we can build a a geode bot
            canBuildNothing = !canBuildGeodeBot &&
               # don't idle if we have already hoarded more clay and ore than we need
               (curr.ore < 2*[bp.geodeBotOre,bp.obsBotOre,bp.clayBotOre].max) &&
               (curr.clay < 3*bp.obsBotClay)

            # push build nothing state only 
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
   return best
end

puts blueprints.map { |bp|
   getBestGeodes(bp, 24) * bp.id
}.sum

puts blueprints[0..2].map { |bp|
   getBestGeodes(bp, 32)
}.inject(1,:*)

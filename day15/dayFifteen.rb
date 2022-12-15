inputList = IO.readlines("day15/dayFifteenInput.txt").map(&:chomp)

Point = Struct.new(:x,:y)

input = inputList.map{ |line|
   nums = line.scan(/-?\d+/).map(&:to_i)
   s = Point.new(nums[0],nums[1])
   b = Point.new(nums[2],nums[3])
   # manhattan distance to beacon from sensor
   dist = (s.x - b.x).abs + (s.y - b.y).abs
   # track sensor, beacon, and manhattan distance
   [s,b,dist]
}

# input an array of ranges, get an array of merged ranges
def mergeRanges(ranges)
   mergedRanges = []
   # sort the ranges so we can merge them
   ranges = ranges.sort_by(&:begin)
   testRange = ranges.shift
   while(ranges.size>0)
      range = ranges.shift
      if(testRange.end >= range.begin)
         # we have overlap, create a new range and continue checking
         # for merge opportunities
         testRange = [testRange.begin,range.begin].min..[testRange.end,range.end].max
      else
         # doesn't overlap, keep the current test range and check
         # the next range
         mergedRanges << testRange
         testRange = range
      end
   end
   mergedRanges << testRange
   return mergedRanges
end

def getRanges(input, row)
   ranges = input.map { |s,b,dist|
      # span is manhattan distance left after we trvel
      # to target row from current sensor
      span = dist - (s.y - row).abs
      if(span>=0)
         # we can reach that span left or right from
         # intersection point of Sensor's column with
         # the current target row
         ((s.x-span)..(s.x+span))
      end
   }.compact
   return mergeRanges(ranges)
end

[2_000_000].each { |row|
   ranges = getRanges(input, row)

   beaconCnt = input.map { |s,b,dist|
      b if((b.y==row)) # find beacons on the target row
   }.compact.uniq.size

   puts ranges.map(&:size).sum - beaconCnt
}

4_000_000.times { |row|
   ranges = getRanges(input, row)
   if(ranges.size>1)
      puts (ranges[0].end+1)*4_000_000 + row
      break
   end
}

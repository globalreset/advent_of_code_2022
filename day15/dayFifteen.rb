inputList = IO.readlines("day15/dayFifteenInput.txt").map(&:chomp)

input = inputList.map{ |line|
   nums = line.scan(/-?\d+/).map(&:to_i)
   s = nums[0..1]
   b = nums[2..3]
   # manhattan distance to beacon from sensor
   dist = (s[0] - b[0]).abs + (s[1] - b[1]).abs
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
         testRange = [testRange.min,range.min].min..[testRange.max,range.max].max
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
      span = dist - (s[1] - row).abs
      if(span>=0)
         # we can reach that span left or right from
         # intersection point of Sensor's column with
         # the current target row
         ((s[0]-span)..(s[0]+span))
      end
   }.compact
   return mergeRanges(ranges)
end

[2_000_000].each { |row|
   ranges = getRanges(input, row)

   beaconCnt = input.map { |s,b,dist|
      b if((b[1]==row)) # find beacons on the target row
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

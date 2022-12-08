inputList = IO.readlines("day8/dayEightInput.txt").map(&:chomp)

treeMap = []
inputList.each { |line|
   treeMap << line.split('').map(&:to_i)
}

visibleCnt = treeMap[0].size*2 + (treeMap.size - 2)*2

(1...(treeMap[0].size-1)).each { |col|
   (1...(treeMap.size-1)).each { |row|
      visibleCnt += [
         treeMap[row][(col+1)..-1].max,
         treeMap[row][0..(col-1)].max,
         treeMap[0..(row-1)].map { |c| c[col] }.max,
         treeMap[(row+1)..-1].map { |c| c[col] }.max
      ].map { |m| 1 if(treeMap[row][col] > m) }.compact.max || 0
   }
}

p visibleCnt

scenicScore = []
(1...(treeMap[0].size-1)).each { |col|
   (1...(treeMap.size-1)).each { |row|
      scenicScore << [
         treeMap[row][(col+1)..-1],
         treeMap[row][0..(col-1)].reverse,
         treeMap[0..(row-1)].map { |c| c[col] }.reverse,
         treeMap[(row+1)..-1].map { |c| c[col] }
      ].map { |vec|
         treeCnt = 0
         vec.each { |t|
            treeCnt += 1
            if(t >= treeMap[row][col])
               break
            end
         }
         treeCnt
      }.inject(1, &:*)
   }
}
p scenicScore.max
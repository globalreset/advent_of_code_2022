inputList = IO.readlines("day8/dayEightInput.txt").map(&:chomp)

treeMap = []
inputList.each { |line|
   treeMap << line.split('').map(&:to_i)
}

visibleCnt = treeMap[0].size*2 + (treeMap.size - 2)*2

(1...(treeMap[0].size-1)).each { |row|
   (1...(treeMap.size-1)).each { |col|
      visibleCnt += [
         treeMap[col][(row+1)..-1].max,
         treeMap[col][0..(row-1)].max,
         treeMap[0..(col-1)].map { |c| c[row] }.max,
         treeMap[(col+1)..-1].map { |c| c[row] }.max
      ].map { |m| 1 if(treeMap[col][row] > m) }.compact.max || 0
   }
}

p visibleCnt

scenicScore = []
(1...(treeMap[0].size-1)).each { |row|
   (1...(treeMap.size-1)).each { |col|
      scenicScore << [
         treeMap[col][(row+1)..-1],
         treeMap[col][0..(row-1)].reverse,
         treeMap[0..(col-1)].map { |c| c[row] }.reverse,
         treeMap[(col+1)..-1].map { |c| c[row] }
      ].map { |vec|
         treeCnt = 0
         vec.each { |t|
            treeCnt += 1
            if(t >= treeMap[col][row])
               break
            end
         }
         treeCnt
      }.inject(1, &:*)
   }
}
p scenicScore.max
inputList = IO.readlines("day5/dayFiveInput.txt").map(&:chomp)

columns = []
moves = []
inputList.each { |i|
   if(i=="" || i =~ /^ *1/)
      #ignore
   elsif(i =~ /move (\d+) from (\d+) to (\d+)/)
      moves << [Regexp.last_match(1).to_i,
                Regexp.last_match(2).to_i-1,
                Regexp.last_match(3).to_i-1]
   else
      i.scan(/ ?(\[[A-Z]\]|   )/).flatten.each_with_index { |c, idx|
         unless(c=~/   /)
            (columns[idx] ||= []).unshift(c[/[A-Z]/])
         end
      }
   end
}
origColumns = columns.map{|col|col.dup}

moves.each { |m|
   qty, src, dst = m
   qty.times {
      columns[dst].push(columns[src].pop)
   }
}

p columns.map{|col| col[-1]}.join("")

columns = origColumns
moves.each { |m|
   qty, src, dst = m
   columns[src].pop(qty).each{|i|
     columns[dst].push(i)
   }
}

p columns.map{|col| col[-1]}.join("")
inputList = IO.readlines("day11/dayElevenInput.txt").map(&:chomp)

#run twice, once for part 1 and once for part 2
2.times { |i|
   monkeys = {}
   currMonkey = {}
   inputList.each { |line|
      if(line=~/Monkey (\d+)/)
         currMonkey = {}
         monkeys[Regexp.last_match(1).to_i] = currMonkey
      elsif(line=~/Starting items: (.*)/)
         currMonkey["items"] = Regexp.last_match(1).split(", ").map(&:to_i)
      elsif(line=~/Operation: new = (.*)/)
         currMonkey["op"] = Regexp.last_match(1)
      elsif(line=~/Test: divisible by (\d+)/)
         currMonkey["test"] = Regexp.last_match(1).to_i
      elsif(line=~/If true: .* monkey (\d+)/)
         currMonkey["nextMonkeyTrue"] = Regexp.last_match(1).to_i
      elsif(line=~/If false: .* monkey (\d+)/)
         currMonkey["nextMonkeyFalse"] = Regexp.last_match(1).to_i
      end
   }
   
   if(i==0)
      #Part 1
      rounds = 20
      worryOp = "/"
      worryDiv = 3
   else
      #Part 2
      rounds = 10_000
      worryOp = "%"
      worryDiv = monkeys.values.map { |m| m["test"] }.inject(1,&:*)
   end
   
   rounds.times { |i|
      monkeys.values.each { |m|
         m["inspectionCnt"] ||= 0
         while(m["items"].size()>0) do
            m["inspectionCnt"] += 1
            item = m["items"].shift
            item = eval m["op"].gsub(/old/, item.to_s)
            item = eval "#{item} #{worryOp} #{worryDiv}"
            if((item % m["test"])==0)
               monkeys[m["nextMonkeyTrue"]]["items"].push(item)
            else
               monkeys[m["nextMonkeyFalse"]]["items"].push(item)
            end
         end
      }
   }
   p monkeys.values.map{|i| i["inspectionCnt"] }.sort[-2..-1].inject(1, &:*)
}
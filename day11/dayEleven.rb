inputList2 = IO.readlines("day11/dayElevenInput.txt").map(&:chomp)

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
p monkeys

gcd = monkeys.values.map { |m| m["test"] }.inject(1,&:*)

#20.times { |i|
10000.times { |i|
   monkeys.values.each { |m|
      m["inspectionCnt"] ||= 0
      while(m["items"].size()>0) do
         m["inspectionCnt"] += 1
         item = m["items"].shift
         item = eval m["op"].gsub(/old/, item.to_s)
         #item = item/3
         item = item%gcd
         if((item % m["test"])==0)
            monkeys[m["nextMonkeyTrue"]]["items"].push(item)
         else
            monkeys[m["nextMonkeyFalse"]]["items"].push(item)
         end
      end
   }
}


p monkeys.values.map{|i| i["inspectionCnt"] }.sort[-2..-1].inject(1, &:*)
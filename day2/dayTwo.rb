inputList = IO.readlines("day2/dayTwoInput.txt").map(&:chomp)

wins = { 
   :rock => :scissors, 
   :scissors => :paper, 
   :paper => :rock
}
loses = wins.map(&:reverse).to_h

scoreTbl = { :rock => 1, :paper => 2, :scissors => 3}

dec = { 
   "A" => :rock, "B" => :paper, "C" => :scissors,
   "X" => :rock, "Y" => :paper, "Z" => :scissors
}

moveList = inputList.map(&:split)

score = 0
moveList.each { |p1,p2|
   p1 = dec[p1]
   p2 = dec[p2]
   if(p1==p2)
      score += 3
   elsif(p1==wins[p2])
      score += 6
   end
   score += scoreTbl[p2]
}
puts score

#X - lose, Y - draw, Z - win
score = 0
moveList.each { |p1,p2|
   p1 = dec[p1]
   p2 = case(p2)
        when "X"
           wins[p1]
        when "Y"
           score += 3
           p1
        when "Z"
           score += 6
           loses[p1]
        end
   score += scoreTbl[p2]
}
puts score
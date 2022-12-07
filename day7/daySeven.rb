inputList = IO.readlines("day7/daySevenInput.txt").map(&:chomp)

dirDirs = {}
dirFiles = {}
currDir = ["/"]
inputList.each { |line|
   if(line =~ /\$ cd (.*)/)
      if(Regexp.last_match(1)=="")
         currDir = ["/"]
      elsif(Regexp.last_match(1)=="..")
         currDir.pop
      else
         currDir.push(Regexp.last_match(1))
      end
   elsif(line =~ /^dir (.*)/)
      (dirDirs[File.join(currDir)] ||= []).push(Regexp.last_match(1))
   elsif(line =~ /^([0-9]+) (.*)/)
      (dirFiles[File.join(currDir)] ||= []).push([Regexp.last_match(1), Regexp.last_match(2)])
   end
}

def getDirSize(dir, dirDirs, dirFiles, dirSize)
   size = 0
   if(dirFiles[dir]) 
      dirFiles[dir].each { |file| size += file[0].to_i }
   end
   if(dirDirs[dir])
      size += dirDirs[dir].map { |subDir| 
         getDirSize(File.join(dir,subDir), dirDirs, dirFiles, dirSize) 
      }.sum
   end
   dirSize[dir] = size
   return size
end

dirSize = {}
getDirSize("/", dirDirs, dirFiles, dirSize)

totalSize = 0
puts dirSize.values.find_all { |i| i<=100000 }.sum

freeSpace = 70000000 - dirSize["/"]
target = 30000000 - freeSpace
puts dirSize.values.sort.find_all{ |i| i>target }[0]
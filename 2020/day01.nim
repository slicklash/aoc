import sequtils, strutils

proc part1(numbers: seq[int]): int =
  for i, x in numbers:
    for y in numbers[i+1..^1]:
      if x + y == 2020:
        return x * y

proc part2(numbers: seq[int]): int =
  for i, x in numbers:
    for j, y in numbers[i+1..^1]:
      for z in numbers[j+1..^1]:
        if x + y + z == 2020:
          return x * y * z

when isMainModule:
  let numbers = toSeq(lines("day01.txt")).map(parseInt)
  doAssert part1(numbers) == 158916
  doAssert part2(numbers) == 165795564

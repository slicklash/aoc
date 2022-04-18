import math, re, sequtils, strutils

proc part1(xs: seq[int], days = 80): int =
  var cx: array[9,int]
  for x in xs:
    cx[x] += 1
  for n in 1 .. days:
    let reset = cx[0]
    for i in 1 .. 8:
      cx[i - 1] = cx[i]
    cx[8] = reset
    cx[6] += reset
  result = cx.sum

proc part2(xs: seq[int]): int = part1(xs, 256)

when isMainModule:
  let xs = lines("day06.txt").toSeq[0].findAll(re"-?\d+").map(parseInt)
  doAssert part1(xs) == 371379
  doAssert part2(xs) == 1674303997472

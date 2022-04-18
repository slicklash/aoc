import math, strutils, sequtils

proc part1(xs: seq[int]): int =
  let (lo, hi) = (xs.min, xs.max)
  var sums: seq[int]
  for p in lo .. hi:
    sums.add xs.mapIt(abs(p - it)).sum
  result = sums.min

proc part2(xs: seq[int]): int =
  let (lo, hi) = (xs.min, xs.max)
  let sn = proc (n: int): int = n*(1+n) div 2
  var sums: seq[int]
  for p in lo .. hi:
    sums.add xs.mapIt(abs(p - it).sn).sum
  result = sums.min

when isMainModule:
  let xs = lines("day07.txt").toSeq[0].split(',').map(parseInt)
  doAssert part1(xs) == 323647
  doAssert part2(xs) == 87640209

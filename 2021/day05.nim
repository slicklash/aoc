import math, re, sequtils, strutils, tables

proc angle(x1, y1, x2, y2: int): int
proc countOverlap(lines: seq[string], angles: openArray[int]): int

proc part1(xs: seq[string]): int = countOverlap(xs, @[90])
proc part2(xs: seq[string]): int = countOverlap(xs, @[45, 90])

proc countOverlap(lines: seq[string], angles: openArray[int]): int =
  var cx: CountTable[(int, int)]
  for line in lines:
    let xs = line.findAll(re"-?\d+").map(parseInt)
    let (x1, y1, x2, y2) = (xs[0], xs[1], xs[2], xs[3])
    let a = angle(x1, y1, x2, y2)
    if any(angles, proc(t: int): bool = a mod t == 0):
      var (nx, ny) = (x1, y1)
      let dx = min(1, max(x2 - x1, -1))
      let dy = min(1, max(y2 - y1, -1))
      cx.inc((nx, ny))
      while nx != x2 or ny != y2:
        nx += dx
        ny += dy
        cx.inc((nx, ny))
  result = cx.values.toSeq.filterIt(it > 1).len

proc angle(x1, y1, x2, y2: int): int =
  let dy = (y1 - y2).toFloat
  let dx = (x2 - x1).toFloat
  var degs = arctan2(dy,dx).radToDeg
  if degs < 0 : degs += 360
  return degs.toInt

when isMainModule:
  let xs = lines("day05.txt").toSeq
  doAssert part1(xs) == 6710
  doAssert part2(xs) == 20121

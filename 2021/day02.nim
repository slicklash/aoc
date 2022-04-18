import sequtils, strutils

proc part1(xs: seq[(string, int)]): int =
  var dx, dy: int
  for (cmd, n) in xs:
    case cmd
      of "up": dy -= n
      of "down": dy += n
      of "forward": dx += n
      else: discard
  result = dx * dy

proc part2(xs: seq[(string, int)]): int =
  var dx, dy, aim: int
  for (cmd, n) in xs:
    case cmd
      of "up": aim -= n
      of "down": aim += n
      of "forward":
        dx += n
        dy += aim * n
      else: discard
  result = dx * dy

when isMainModule:
  let xs = lines("day02.txt").toSeq.mapIt(it.split(' ')).mapIt((it[0], it[1].parseInt))
  doAssert part1(xs) == 1947824
  doAssert part2(xs) == 1813062561

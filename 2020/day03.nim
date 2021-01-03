import sequtils

proc part1(xs: seq[string], deltas: (int, int)): int =
  let (dx, dy) = deltas
  var (x, y) = (dx, dy)
  let edge = xs[0].len
  while y < xs.len:
    if xs[y][x] == '#':
      inc(result)
    x = (x + dx) mod edge
    y += dy

proc part2(xs: seq[string]): int =
  let slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
  result = slopes.foldl(a * part1(xs, b), 1)

when isMainModule:
  let lines = toSeq(lines("day03.txt"))
  doAssert part1(lines, (3, 1)) == 187
  doAssert part2(lines) == 4723283400

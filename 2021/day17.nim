import math, re, sequtils, strutils

type
  Point = (int, int)
  Bounds = tuple[left: int, top: int, right: int, bottom: int]

proc hits(target: Bounds): seq[int]

proc part1(target: Bounds): int = hits(target).max
proc part2(target: Bounds): int = hits(target).len

proc step(x, y, vx, vy: var int) =
  x += vx
  y += vy
  vx += -sgn(vx)
  vy.dec

proc `in`(p: Point, b: Bounds): bool =
  p[0] >= b.left and p[0] <= b.right and
  p[1] >= b.top and p[1] <= b.bottom

proc launch(velo: (int, int), target: Bounds): (bool, int) =
  var (vx, vy) = velo
  var x, y: int
  var maxy = -int.high
  while x <= target.right and y >= target.top:
    step(x, y, vx, vy)
    maxy = max(maxy, y)
    if (x, y) in target: return (true, maxy)

proc hits(target: Bounds): seq[int] =
  for vx in 0 .. target.right:
    for vy in target.top .. target.top.abs:
      let (hit, maxy) = launch((vx, vy), target)
      if hit: result.add(maxy)

when isMainModule:
  let xs = readFile("day17.txt").findAll(re"-?\d+").map(parseInt)
  let target: Bounds = (xs[0], xs[2], xs[1], xs[3])
  doAssert part1(target) == 19503
  doAssert part2(target) == 5200

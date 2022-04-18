import math, re, sequtils, strutils

type
  Step = (bool, Cuboid)
  Cuboid = tuple
    x1, x2, y1, y2, z1, z2: int

proc toCuboids(xs: seq[Step]): seq[Cuboid]
proc volume(c: Cuboid): int = (c.x2 - c.x1 + 1) * (c.y2 - c.y1 + 1) * (c.z2 - c.z1 + 1)
proc `in`(a, b: Cuboid): bool

proc part1(xs: seq[Step]): int =
  result = xs.filterIt(
    it[1].x1 >= -50 and it[1].x2 <= 50 and
    it[1].y1 >= -50 and it[1].y2 <= 50 and
    it[1].z1 >= -50 and it[1].z2 <= 50)
     .toCuboids.map(volume).sum

proc part2(xs: seq[Step]): int = xs.toCuboids.map(volume).sum

proc toCuboids(xs: seq[Step]): seq[Cuboid] =
  for x in xs:
    let (switchOn, nc) = x
    var cuboids: seq[Cuboid]
    for c in result:
      if c in nc:
        if c.x1 < nc.x1: # left of nc
          cuboids.add((c.x1, nc.x1 - 1, c.y1, c.y2, c.z1, c.z2))
        if c.x2 > nc.x2: # right of nc
          cuboids.add((nc.x2 + 1, c.x2, c.y1, c.y2, c.z1, c.z2))
        if c.y1 < nc.y1: # bellow nc
          cuboids.add((max(c.x1, nc.x1), min(c.x2, nc.x2), c.y1, nc.y1 - 1, c.z1, c.z2))
        if c.y2 > nc.y2: # above nc
          cuboids.add((max(c.x1, nc.x1), min(c.x2, nc.x2), nc.y2 + 1, c.y2, c.z1, c.z2))
        if c.z1 < nc.z1: # in front of nc
          cuboids.add((max(c.x1, nc.x1), min(c.x2, nc.x2), max(c.y1, nc.y1), min(c.y2, nc.y2), c.z1, nc.z1 - 1))
        if c.z2 > nc.z2: # behind nc
          cuboids.add((max(c.x1, nc.x1), min(c.x2, nc.x2), max(c.y1, nc.y1), min(c.y2, nc.y2), nc.z2 + 1, c.z2))
      else:
        cuboids.add(c)
    if switchOn:
      cuboids.add(nc)
    result = cuboids

proc `in`(a, b: Cuboid): bool =
  not (a.x1 > b.x2 or a.x2 < b.x1 or
       a.y1 > b.y2 or a.y2 < b.y1 or
       a.z1 > b.z2 or a.z2 < b.z1)

proc parse(xs: seq[string]): seq[Step] =
  for s in xs:
    let x = s.findAll(re"-?\d+").map(parseInt)
    result.add(("on" in s, (x[0], x[1], x[2], x[3], x[4], x[5])))

when isMainModule:
  let steps = lines("day22.txt").toSeq.parse
  doAssert part1(steps) == 587097
  doAssert part2(steps) == 1359673068597669

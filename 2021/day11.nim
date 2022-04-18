import intsets, math, sequtils, sets, strutils, tables

type
  Point = (int, int)
  Grid = object
    tiles: Table[Point, int]
    points: seq[Point]

proc parse(xs: seq[string]): Grid
proc flash(grid: Grid, n: int): int

proc part1(xs: seq[string]): int = xs.parse.flash(100)
proc part2(xs: seq[string]): int = xs.parse.flash(100_000_000)

const Deltas = @[(-1,-1), (0,-1), (1,-1), (-1,0), (1,0), (-1,1), (0,1), (1,1)]
iterator neighbours[T](grid: Table[Point, T], p: Point): (Point, T) =
  for (dx, dy) in Deltas:
    let key = (p[0] + dx, p[1] + dy)
    if grid.hasKey(key):
      yield (key, grid[key])

proc flash(grid: Grid, n: int): int =
  var g = grid
  for step in 1 .. n:
    for p in g.points:
      g.tiles[p] += 1
    var flashed: HashSet[Point]
    var more = true
    while more:
      more = false
      for p in g.points:
        if g.tiles[p] > 9:
          g.tiles[p] = 0
          flashed.incl(p)
          inc result
          for (n, v) in neighbours(g.tiles, p):
            if n notin flashed:
              g.tiles[n] += 1
              more = true
    if g.tiles.values.toSeq.sum == 0:
      return step

proc parse(xs: seq[string]): Grid =
  for x in 0 .. xs[0].high:
    for y in 0 .. xs.high:
      let c = $xs[y][x]
      result.points.add((x, y))
      result.tiles[(x, y)] = c.parseInt

when isMainModule:
  let xs = lines("day11.txt").toSeq
  doAssert part1(xs) == 1729
  doAssert part2(xs) == 237

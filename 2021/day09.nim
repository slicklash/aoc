import algorithm, sequtils, sets, strutils, tables

type
  Point = (int, int)
  Grid = object
    tiles: Table[Point, int]
    points: seq[Point]

proc parse(xs: seq[string]): Grid
proc basin(g: Grid, start: Point): HashSet[Point]

const Deltas = @[(-1,0), (1,0), (0,-1), (0,1)]
iterator neighbours[T](grid: Table[Point, T], p: Point): (Point, T) =
  for (dx, dy) in Deltas:
    let key = (p[0] + dx, p[1] + dy)
    if grid.hasKey(key):
      yield (key, grid[key])

proc part1(g: Grid): int =
  for p in g.points:
    let ns = neighbours(g.tiles, p).toSeq
    if ns.allIt(it[1] > g.tiles[p]):
      result += g.tiles[p] + 1

proc part2(g: Grid): int =
  var basins: seq[int]
  var seen: HashSet[Point]
  for p in g.points:
    if g.tiles[p] == 9 or p in seen:
      continue
    let b = basin(g, p)
    seen = seen + b
    basins.add(b.len)
  result = basins.sorted[^3 .. ^1].foldl(a * b)

proc basin(g: Grid, start: Point): HashSet[Point] =
  var stack = @[start]
  while stack.len > 0:
    let p = stack.pop()
    result.incl(p)
    for (np, v) in neighbours(g.tiles, p):
      if not (np in result) and v != 9:
        stack.add(np)

proc parse(xs: seq[string]): Grid =
  for x in 0 .. xs[0].high:
    for y in 0 .. xs.high:
      let p = (x,y)
      result.points.add(p)
      result.tiles[p] = ($xs[y][x]).parseInt

when isMainModule:
  let g = lines("day09.txt").toSeq.parse
  doAssert part1(g) == 486
  doAssert part2(g) == 1059300

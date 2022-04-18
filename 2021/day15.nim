import heapqueue, sequtils, sets, strutils, tables

type
  Point = (int, int)
  Grid = object
    points: HashSet[Point]
    tiles: Table[Point, int]
    width: int
    height: int

proc parse(xs: seq[string]): Grid
proc astar(g: Grid, start, finish: Point): int

proc part1(g: Grid): int = astar(g, (0,0), (g.width - 1, g.height - 1))

proc part2(g: var Grid, repeat = 5): int =
  let points = g.points
  for dx in 0 ..< repeat:
    for dy in 0 ..< repeat:
      if dx == 0 and dy == 0: continue
      for p in points:
        let nx = p[0] + dx * g.width
        let ny = p[1] + dy * g.height
        let np = (nx, ny)
        let nv = g.tiles[p] + dx + dy
        g.tiles[np] = if nv > 9: nv mod 9 else: nv
        g.points.incl(np)
  g.width *= repeat
  g.height *= repeat
  result = part1(g)

const Deltas = @[(-1,0), (1,0), (0,-1), (0,1)]
iterator neighbours[T](grid: Table[Point, T], p: Point): (Point, T) =
  for (dx, dy) in Deltas:
    let key = (p[0] + dx, p[1] + dy)
    if grid.hasKey(key):
      yield (key, grid[key])

proc dist(a, b: Point): int = abs(a[0] - b[0]) + abs(a[1] - b[1])

proc astar(g: Grid, start, finish: Point): int =
  var costFromStart = {start: 0}.toTable
  var queue = @[(0, start)].toHeapQueue
  while queue.len > 0:
    let (_, p) = queue.pop
    if p == finish: break
    for (np, c) in neighbours(g.tiles, p):
      let pathCost = costFromStart[p] + c
      if pathCost < costFromStart.getOrDefault(np, int.high):
        costFromStart[np] = pathCost
        queue.push((pathCost + np.dist(finish), np))
  result = costFromStart.getOrDefault(finish)

proc parse(xs: seq[string]): Grid =
  result.width = xs[0].len
  result.height = xs.len
  for x in 0 .. xs[0].high:
    for y in 0 .. xs.high:
      result.points.incl((x, y))
      result.tiles[(x, y)] = ($xs[y][x]).parseInt

when isMainModule:
  var g = lines("day15.txt").toSeq.parse
  doAssert part1(g) == 755
  doAssert part2(g) == 3016

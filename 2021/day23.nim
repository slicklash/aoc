import heapqueue, intsets, math, sequtils, sets, strutils, tables

type
  Point = tuple[x, y: int]
  Tile = tuple[val: char, moved: int, total: int]
  Grid = object
    points: seq[Point]
    tiles: Table[Point, Tile]
    width: int
    height: int

proc parse(xs: seq[string]): Grid
proc move(g: var Grid, p, to: Point)
proc solve(g: Grid, cache = newTable[string, int]()): int

proc part1(xs: seq[string]): int =
  var g = xs.parse
  g.move((7, 2), (1, 1))
  g.move((9, 2), (10, 1))
  g.move((9, 3), (4, 1))
  result = g.solve

proc part2(xs: seq[string]): int =
  var g = (xs[0..2] & @["  #D#C#B#A#", "  #D#B#A#C#"] & xs[3..^1]).parse
  g.move((7, 2), (11, 1))
  g.move((7, 3), (10, 1))
  g.move((7, 4), (1, 1))
  g.move((5, 2), (2, 1))
  result = g.solve

const Deltas = @[(-1,0), (1,0), (0,-1), (0,1)]
iterator neighbours[T](grid: Table[Point, T], p: Point): (Point, T) =
  for (dx, dy) in Deltas:
    let key = (p[0] + dx, p[1] + dy)
    if grid.hasKey(key):
      yield (key, grid[key])

proc pathLength(grid: Grid, start, finish: Point): int =
  var costFromStart = {start: 0}.toTable
  var queue = @[(0, start)].toHeapQueue
  while queue.len > 0:
    let (_, pos) = queue.pop
    if pos == finish: break
    for (newPos, c) in neighbours(grid.tiles, pos):
      if c.val != '.': continue
      let pathCost = costFromStart[pos] + 1
      if pathCost < costFromStart.getOrDefault(newPos, int.high):
        costFromStart[newPos] = pathCost
        queue.push((pathCost, newPos))
  result = costFromStart.getOrDefault(finish)

proc parse(xs: seq[string]): Grid =
  result.width = xs[0].len
  result.height = xs.len
  for x in 0 .. xs[0].high:
    for y in 0 .. xs.high:
      let c = if xs[y].high < x: ' ' else: xs[y][x]
      if c notin "# ":
        result.points.add((x,y))
      result.tiles[(x, y)] = (c, 0, 0)

proc isHall(p: Point): bool = p[1] == 1
proc isRoom(p: Point): bool = p[1] > 1
proc isAmphipod(g: Grid, p: Point): bool = g.tiles[p].val in "ABCD"
proc forbidden(t: Point): bool = t.y == 1 and t.x in @[3,5,7,9]

const VALID_ROOMS = {
  'A': @[(3,5), (3,4), (3,3), (3,2)].toHashSet,
  'B': @[(5,5), (5,4), (5,3), (5,2)].toHashSet,
  'C': @[(7,5), (7,4), (7,3), (7,2)].toHashSet,
  'D': @[(9,5), (9,4), (9,3), (9,2)].toHashSet,
}.toTable

proc emptyRooms(g: Grid, amphi: char): seq[Point] =
  for p in VALID_ROOMS[amphi]:
    if p in g.points and g.tiles[p].val == '.':
      result.add(p)

proc canMove(g: Grid, p, to: Point): bool =
  let tile = g.tiles[p]
  if tile.val notin "ABCD": return false
  if g.pathLength(p, to) == 0: return false
  if to.isHall and tile.moved == 0 and not to.forbidden: return true
  let validRooms = VALID_ROOMS[tile.val].toSeq.filterIt(it in g.points)
  if to.isRoom and tile.moved < 2 and
    to in validRooms and
    not (to.x == p.x and p.y > to.y) and
    validRooms.allIt(g.tiles[it].val in @['.', tile.val]) and
    g.tiles[(to.x, to.y + 1)].val != '.':
    return true

proc cost(g: Grid): int =
  for p in g.points:
    let t = g.tiles[p]
    result += t.total * 10 ^ max(0, "ABCD".find(t.val))

proc check(g: Grid): bool =
  for k, v in VALID_ROOMS:
    for p in v:
      if p in g.points and g.tiles[p].val != k:
        return false
  result = true

proc move(g: var Grid, p, to: Point) =
  var t = g.tiles[p]
  t.moved += 1
  t.total += g.pathLength(p, to)
  g.tiles[p] = ('.', 0, 0)
  g.tiles[to] = t

proc key(g: Grid): string = g.points.mapIt($g.tiles[it]).join

proc solve(g: Grid, cache = newTable[string, int]()): int =
  let c = g.cost
  if g.check: return c
  let key = g.key
  if cache.hasKey(key):
    return cache[key]

  var costs: IntSet

  for p in g.points:
    if g.isAmphipod(p):
      var moved = false
      var sub: Grid
      var cost: int
      let empty = g.emptyRooms(g.tiles[p].val)
      for rt in empty:
        if g.canMove(p, rt):
          sub = g
          sub.move(p, rt)
          moved = true
          cost = sub.solve(cache)
          if cost > 0: costs.incl(cost)
      if not moved:
        for to in g.points:
          if to.y > 1: continue
          if g.canMove(p, to):
            sub = g
            sub.move(p, to)
            cost = sub.solve(cache)
            if cost > 0: costs.incl(cost)
  if costs.len > 0:
    result = costs.toSeq.min
  cache[key] = result

when isMainModule:
  let xs = lines("day23.txt").toSeq
  doAssert part1(xs) == 13495
  doAssert part2(xs) == 53767

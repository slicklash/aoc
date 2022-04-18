import sequtils, tables

type
  Point = (int, int)
  Grid = object
    points: seq[Point]
    tiles: Table[Point, char]
    width: int
    height: int

const Moves = @[('>', 1, 0), ('v', 0, 1)]

proc parse(xs: seq[string]): Grid
proc move(g: Grid, m: (char, int, int)): Grid
proc `[]`(g: Grid, p: Point): char = g.tiles[p]
proc `[]=`(g: var Grid, p: Point, c: char) = g.tiles[p] = c

proc part1(g: var Grid): int =
  var prev: Grid
  while g != prev:
    prev = g
    inc result
    for m in Moves:
      g = g.move(m)

proc move(g: Grid, m: (char, int, int)): Grid =
  result = g
  let (c, dx, dy) = m
  for p in g.points:
    let nx = (p[0] + dx) mod g.width
    let ny = (p[1] + dy) mod g.height
    let np = (nx, ny)
    if g[p] == c and g[np] == '.':
      result[p] = '.'
      result[np] = c

proc parse(xs: seq[string]): Grid =
  result.width = xs[0].len
  result.height = xs.len
  for x in 0 .. xs[0].high:
    for y in 0 .. xs.high:
      result.points.add((x, y))
      result[(x, y)] = xs[y][x]

when isMainModule:
  var g = lines("day25.txt").toSeq.parse
  doAssert part1(g) == 360

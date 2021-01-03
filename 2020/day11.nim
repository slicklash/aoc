import sequtils, tables

type
  Point = (int, int)
  Grid = Table[Point, char]
  GridInfo = tuple[grid: Grid, width: int, height: int]

proc parse(lines: seq[string]): (Grid, int, int) =
  var grid: Grid
  for x in 0..lines[0].high:
    for y in 0..lines.high:
      grid[(x,y)] = lines[y][x]
  result = (grid, lines[0].high, lines.high)

const Deltas = @[(-1,-1), (0,-1), (1,-1), (-1,0), (1,0), (-1,1), (0,1), (1,1)]

proc neighbours(grid: Grid, x: int, y: int): int =
  for (dx, dy) in Deltas:
    let key = (x + dx, y + dy)
    if grid.getOrDefault(key) == '#':
      inc(result)

proc neighboursVisible(grid: Grid, x: int, y: int): int =
  for (dx, dy) in Deltas:
    var (nx, ny, c) = (x, y, '.')
    while c == '.':
      nx += dx
      ny += dy
      c = grid.getOrDefault((nx, ny), '-')
    if c == '#':
      inc(result)

proc solve(gridInfo: GridInfo, tolerance: int, neighbours: proc): int =
  var (grid, width, height) = gridInfo
  while true:
    var copy = grid
    for x in 0..width:
      for y in 0..height:
        let key = (x, y)
        let c = grid[key]
        if c == '.':
          continue
        let n = neighbours(grid, x, y)
        if c == 'L':
            if n < 1:
              copy[key] = '#'
        else:
            if n >= tolerance:
              copy[key] = 'L'
    if copy == grid:
      break
    grid = copy
  result = toSeq(grid.values).toCountTable['#']

when isMainModule:
  let grid = toSeq(lines("day11.txt")).parse()
  doAssert solve(grid, 4, neighbours) == 2359
  doAssert solve(grid, 5, neighboursVisible) == 2131

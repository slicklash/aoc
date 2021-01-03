import sequtils, strutils, tables

const ROTATE = {
  "RE": "SWN",
  "LE": "NWS",
  "RW": "NES",
  "LW": "SEN",
  "RN": "ESW",
  "LN": "WSE",
  "RS": "WNE",
  "LS": "ENW",
}.toTable()

proc move(x, y: int, direction: char, delta: int): (int, int) =
  result = (case direction
    of 'E': (x + delta, y)
    of 'W': (x - delta, y)
    of 'N': (x, y + delta)
    of 'S': (x, y - delta)
    else: (x, y))

proc part1(xs: seq[string]): int =
  var x, y = 0
  var face = 'E'
  for line in xs:
    var dir = line[0]
    let delta = line[1..^1].parseInt
    if dir == 'F':
      dir = face
    if dir in "EWNS":
      (x, y) = move(x, y, dir, delta)
    elif dir in "RL":
      face = ROTATE[dir & face][delta div 90 - 1]
  result = x.abs + y.abs

proc part2(xs: seq[string]): int =
  var (x, y, dx, dy) = (0, 0, 10, 1)
  for line in xs:
    var dir = line[0]
    var delta = line[1..^1].parseInt
    if dir == 'L':
      dir = 'R'
      delta = 360 - delta
    if dir in "EWNS":
      (dx, dy) = move(dx, dy, dir, delta)
    elif dir == 'F':
      x += dx * delta
      y += dy * delta
    elif dir == 'R':
      (dx, dy) = (case delta
        of 90: (dy, -dx)
        of 180: (-dx, -dy)
        of 270: (-dy, dx)
        else: (dx, dy))
  result = x.abs + y.abs

when isMainModule:
  let lines = toSeq(lines("day12.txt"))
  doAssert part1(lines) == 1956
  doAssert part2(lines) == 126797

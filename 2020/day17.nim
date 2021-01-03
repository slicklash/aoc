import algorithm, sets, sequtils

type
  Point3d = (int, int, int)
  Point4d = (int, int, int, int)

const Range = @[-1,0,1]
const Deltas3d = product(@[Range, Range, Range]).mapIt((it[0], it[1], it[2])).filterIt(it != (0, 0, 0))
const Deltas4d = product(@[Range, Range, Range, Range]).mapIt((it[0], it[1], it[2], it[3])).filterIt(it != (0, 0, 0, 0))

proc parse[T](lines: seq[string], toPoint: proc (x, y: int): T): HashSet[T] =
  for y in 0..lines.high:
    for x in 0..lines[0].high:
      if lines[y][x] == '#':
        result.incl(toPoint(x, y))

proc neighbours(pos: Point3d): HashSet[Point3d] =
  for (dx, dy, dz) in Deltas3d:
    result.incl((pos[0] + dx, pos[1] + dy, pos[2] + dz))

proc neighbours(pos: Point4d): HashSet[Point4d] =
  for (dx, dy, dz, dw) in Deltas4d:
    result.incl((pos[0] + dx, pos[1] + dy, pos[2] + dz, pos[3] + dw))

proc expand[T](state: T): T =
  result = state
  for p in state:
    result = result + p.neighbours

proc cycle[T](state: T): T =
  for p in expand(state):
    let n = (p.neighbours * state).len
    let isActive = p in state
    if (isActive and n in @[2, 3]) or (not isActive and n == 3):
      result.incl(p)

proc part1(lines: seq[string]): int =
  var state = parse[Point3d](lines, proc(x, y: int): Point3d = (x, y, 1))
  for _ in 1..6:
    state = cycle(state)
  result = state.len

proc part2(lines: seq[string]): int =
  var state = parse[Point4d](lines, proc(x, y: int): Point4d = (x, y, 1, 1))
  for _ in 1..6:
    state = cycle(state)
  result = state.len

when isMainModule:
  let lines = toSeq(lines("day17.txt"))
  doAssert part1(lines) == 289
  doAssert part2(lines) == 2084

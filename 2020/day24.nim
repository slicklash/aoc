import re, sets, sequtils, strutils, tables

type
  State = HashSet[(int, int)]

const Directions = "e|se|sw|w|nw|ne"
const Deltas = @[(1,0), (0,-1), (-1,-1), (-1,0), (0,1), (1,1)]
const Moves = zip(Directions.split('|'), Deltas).toTable

proc toPos(line: string): (int, int) =
  for d in line.findAll(re(Directions)):
    let (dx, dy) = Moves[d]
    result[0] += dx
    result[1] += dy

proc parse(lines: seq[string]): State =
  for p in lines.mapIt(it.toPos):
    if p in result:
      result.excl(p)
    else:
      result.incl(p)

proc neighbours(pos: (int, int)): State =
  for (dx, dy) in Deltas:
    result.incl((pos[0] + dx, pos[1] + dy))

proc expand(state: State): State =
  result = state
  for p in state:
    result = result + p.neighbours

proc part1(state: State): int =
  result = state.len

proc part2(state: State, days = 100): int =
  var state = state
  for _ in 1..days:
    var newState: HashSet[(int, int)]
    for p in expand(state):
      let n = (p.neighbours * state).len
      let isBlack = p in state
      if (isBlack and n in @[1, 2]) or (not isBlack and n == 2):
        newState.incl(p)
    state = newState
  result = state.len

when isMainModule:
  let grid = toSeq(lines("day24.txt")).parse
  doAssert part1(grid) == 326
  doAssert part2(grid) == 3979

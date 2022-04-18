import memo, sequtils, strutils, tables

type
  Universe = tuple[p1: int, p2: int, s1: int, s2: int, current: int]

proc countWins(u: Universe): (int, int)

proc part1(pos: seq[int]): int =
  var pos = @pos
  var score = @[0, 0]
  var player, roll, cx: int
  while score[0] < 1000 and score[1] < 1000:
    for _ in 1 .. 3:
      inc roll
      pos[player] += roll
    cx.inc(3)
    while pos[player] > 10: pos[player] -= 10
    score[player] += pos[player]
    player = 1 - player
  result = cx * score.min

proc part2(pos: seq[int]): int =
  let (p1, p2) = (pos[0], pos[1])
  let (w1, w2) = countWins((p1, p2, 0, 0, 0))
  result = max(w1, w2)

proc countWins(u: Universe): (int, int) {.memoized.} =
  for r1 in 1 .. 3:
    for r2 in 1 .. 3:
      for r3 in 1 .. 3:
        var pos = @[u.p1, u.p2]
        var score = @[u.s1, u.s2]
        let p = u.current
        pos[p] += r1 + r2 + r3
        while pos[p] > 10: pos[p] -= 10
        score[p] += pos[p]
        if score[p] > 20:
          if p == 0: result[0].inc
          else: result[1].inc
        else:
          let r = countWins((pos[0], pos[1], score[0], score[1], 1 - p))
          result[0].inc(r[0])
          result[1].inc(r[1])

when isMainModule:
  let pos = lines("day21.txt").toSeq
    .mapIt(it.split(": "))
    .mapIt(it[1].parseInt)

  doAssert part1(pos) == 805932
  doAssert part2(pos) == 133029050096658

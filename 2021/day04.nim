import intsets, math, sequtils, strutils

type
  Card = object
    rows: seq[IntSet]
    cols: seq[IntSet]
    all: IntSet
  Game = (seq[int], seq[Card])

proc parse(txt: string): Game
proc run(game: Game, stop = 1): int

proc part1(game: Game): int = run(game)
proc part2(game: Game): int = run(game, game[1].len)

proc run(game: Game, stop = 1): int =
  var (num, cards) = game
  var seen, done: IntSet
  for draw in num:
    seen.incl(draw)
    for n, c in cards.mpairs:
      if n in done: continue
      for i in 0 .. 4:
        c.cols[i] = c.cols[i] - seen
        c.rows[i] = c.rows[i] - seen
        if c.cols[i].len == 0 or c.rows[i].len == 0:
          done.incl(n)
          if done.len == stop:
            return (c.all - seen).toSeq.sum * draw

proc parse(txt: string): Game =
  let p = txt.split("\n\n")
  result[0] = p[0].split(',').map(parseInt)
  for b in p[1..^1]:
    var c = Card(cols: newSeq[IntSet](5))
    for row, r in b.split('\n').toSeq:
      let xs = r.splitWhitespace.map(parseInt)
      c.rows.add(xs.toIntSet)
      for col, x in xs:
        c.cols[col].incl(x)
        c.all.incl(x)
    result[1].add(c)

when isMainModule:
  let game = readFile("day04.txt").parse
  doAssert part1(game) == 41668
  doAssert part2(game) == 10478

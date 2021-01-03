import deques, hashes, sets, sequtils, strutils

proc parseDeck(s: string): Deque[int] = s.split("\n")[1..^1].mapIt(it.parseInt).toDeque

proc parse(text: string): (Deque[int], Deque[int]) =
  var xs = text.strip.split("\n\n")
  result = (xs[0].parseDeck, xs[1].parseDeck)

proc score(p1, p2: Deque[int]): int =
  let winner = if p1.len > p2.len: p1 else: p2
  for i, x in winner:
    result += x * (winner.len - i)

proc part1(d1, d2: Deque[int]): int =
  var (p1, p2) = (d1, d2)
  while p1.len > 0 and p2.len > 0:
    let c1 = p1.popFirst
    let c2 = p2.popFirst
    if c1 > c2:
      p1.addLast(c1)
      p1.addLast(c2)
    else:
      p2.addLast(c2)
      p2.addLast(c1)
  result = score(p1, p2)

proc take(deque: Deque[int], count: int): Deque[int] =
  for i in 0 ..< count:
    result.addLast(deque[i])

proc play(p1, p2: var Deque[int]): bool =
  var seen1: HashSet[Hash]
  var seen2: HashSet[Hash]
  while p1.len > 0 and p2.len > 0:
    let state1 = p1.toSeq.hash
    let state2 = p2.toSeq.hash
    if state1 in seen1 and state2 in seen2:
      return true
    seen1.incl(state1)
    seen2.incl(state2)
    let c1 = p1.popFirst
    let c2 = p2.popFirst
    var p1won = c1 > c2
    if c1 <= p1.len and c2 <= p2.len:
      var s1 = p1.take(c1)
      var s2 = p2.take(c2)
      p1won = play(s1, s2)
    if p1won:
      p1.addLast(c1)
      p1.addLast(c2)
    else:
      p2.addLast(c2)
      p2.addLast(c1)
  return p1.len > p2.len

proc part2(d1, d2: Deque[int]): int =
  var (p1, p2) = (d1, d2)
  discard play(p1, p2)
  result = score(p1, p2)

when isMainModule:
  let (d1, d2) = readFile("day22.txt").parse
  doAssert part1(d1, d2) == 35818
  doAssert part2(d1, d2) == 34771

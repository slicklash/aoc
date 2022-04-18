import algorithm, sequtils, strutils, tables

const score = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
const pairs = { ')': '(', '(': ')', ']': '[', '[': ']', '}': '{', '{': '}', '<': '>', '>': '<'}.toTable

proc part1(xs: seq[string]): int =
  for x in xs:
    var open: seq[char]
    for i, c in x:
      if c in "([{<":
        open.add(c)
      elif c != pairs[open.pop()]:
        result += score[c]
        break

proc part2(xs: seq[string]): int =
  let points = "_)]}>"
  var scores: seq[int]
  for x in xs:
    var score: int
    var open: seq[char]
    for c in x:
      if c in "([{<":
        open.add(c)
      elif c != pairs[open.pop()]:
        score = -1
        break
    while score > -1 and open.len > 0:
      score = score * 5 + points.find(pairs[open.pop()])
    if score > 0:
      scores.add(score)
  result = scores.sorted[scores.len div 2]

when isMainModule:
  let xs = lines("day10.txt").toSeq
  doAssert part1(xs) == 469755
  doAssert part2(xs) == 2762335572

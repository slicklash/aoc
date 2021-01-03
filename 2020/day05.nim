import algorithm, sequtils

proc toId(pass: string): int =
  var hi = 127 * 8 + 8
  for c in pass:
    var mid = (result + hi) div 2
    if c in "FL":
      hi = mid
    else:
      result = mid

proc part1(passes: seq[string]): (int, seq[int]) =
  let ids = passes.map(toId).sorted
  result = (ids[^1], ids)

proc part2(ids: seq[int]): int =
  for i, x in ids:
    if ids[i+1] - x > 1:
      return x + 1

when isMainModule:
  let passes = toSeq(lines("day05.txt"))
  let (maxId, ids) = part1(passes)
  doAssert maxId == 864
  doAssert part2(ids) == 739

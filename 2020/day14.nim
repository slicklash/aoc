import re, math, sequtils, strutils, tables

proc part1(lines: seq[string]): int =
  var mem: array[2 ^ 16, int]
  var maskKeepX, mask: int
  var m: array[2, string]
  for line in lines:
    if line.match(re"mem\[(\d+)\] = (\d+)", m):
      mem[m[0].parseInt] = (m[1].parseInt or maskKeepX) and mask
    else:
      maskKeepX = line[7..^1].replace('X', '0').parseBinInt
      mask = line[7..^1].replace('X', '1').parseBinInt
  result = mem.sum

proc permutations[T](xs: openArray[T], k: int, prefix: seq[T] = @[]): seq[seq[T]] =
  if k == 1:
    for x in xs:
      result.add(prefix & @[x])
    return result
  for x in xs:
    for p in permutations(xs, k - 1, prefix & @[x]):
      result.add(p)

iterator addresses(mask: string): int =
  var pos: seq[int]
  for i, x in mask:
    if x == 'X':
      pos.add(i)
  for p in permutations(['0', '1'], pos.len):
    var tmp = mask
    for (i, n) in zip(pos, p):
      tmp[i] = n
    yield tmp.parseBinInt

proc part2(lines: seq[string]): int =
  var mem: Table[int, int]
  var mask: string
  var m: array[2, string]
  for line in lines:
    if line.match(re"mem\[(\d+)\] = (\d+)", m):
      var address = m[0].parseInt.toBin(36)
      let value = m[1].parseInt
      for i,x in mask:
        if x in "X1":
          address[i] = x
      for a in addresses(address):
        mem[a] = value
    else:
      mask = line[7..^1]
  result = toSeq(mem.values).sum

when isMainModule:
  let lines = toSeq(lines("day14.txt"))
  doAssert part1(lines) == 7611244640053
  doAssert part2(lines) == 3705162613854

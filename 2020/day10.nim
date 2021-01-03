import algorithm, sequtils, strutils, tables

proc part1(adapters: seq[int]): int =
  var counter: CountTable[int]
  for i in 1..adapters.high:
    counter.inc(adapters[i] - adapters[i-1])
  result = counter[1] * counter[3]

proc part2(adapters:  seq[int]): int =
  var neighbours: Table[int, seq[int]]
  var adapters = adapters.sorted(Descending)
  for i, x in adapters:
    for y in adapters[i+1..^1]:
      if x - y < 4:
        neighbours.mgetOrPut(y, @[]).add(x)
  var counts = {adapters[0]: 1}.toTable()
  for v in adapters:
    for n in neighbours.getOrDefault(v, @[]):
      counts[v] = counts.getOrDefault(v) + counts[n]
  result = counts[0]

when isMainModule:
  var adapters = toSeq(lines("day10.txt")).map(parseInt).sorted
  adapters = @[0] & adapters & @[adapters[^1] + 3]
  doAssert part1(adapters) == 1656
  doAssert part2(adapters) == 56693912375296

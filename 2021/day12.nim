import sequtils, sets, strutils, tables

type
  Graph[T] = Table[T, seq[T]]

proc paths[T](g: Graph, start, finish: T, lower = false): seq[seq[T]]

proc part1(g: Graph): int = paths(g, "start", "end").len
proc part2(g: Graph): int = paths(g, "start", "end", true).len

proc paths[T](g: Graph, start, finish: T, lower = false): seq[seq[T]] =
  var stack = @[(start, newSeq[T]())]
  while stack.len > 0:
    var (v, path) = stack.pop()
    path.add(v)
    if v == finish:
      result.add(path)
      continue
    let allow = lower and path.filterIt(it.toLower == it)
                              .toCountTable.values.toSeq.allIt(it < 2)
    for n in g[v]:
      if (n.allIt(it.isUpperAscii) or
          n notin path or
          (allow and n notin @[start, finish])):
        stack.add((n, path))

when isMainModule:
  let xs = lines("day12.txt").toSeq.mapIt(it.split('-'))

  var g: Graph[string]
  for x in xs:
    let (a, b) = (x[0], x[1])
    g.mgetOrPut(a, @[]).add(b)
    g.mgetOrPut(b, @[]).add(a)

  doAssert part1(g) == 3410
  doAssert part2(g) == 98796

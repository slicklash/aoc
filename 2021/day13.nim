import sequtils, sets, strutils

type
  Point = (int, int)
  Fold = (string, int)
  Grid = object
    points: HashSet[Point]
    width: int
    height: int

proc fold(g: var Grid, fs: seq[Fold]): int
proc show(g: Grid)

proc part1(g: var Grid, fs: seq[Fold]): int = g.fold(@[fs[0]])
proc part2(g: var Grid, fs: seq[Fold]): int =
  result = g.fold(fs)
  g.show

proc fold(g: var Grid, fs: seq[Fold]): int =
  for fold, n in fs.items:
    var fx, fy = int.high
    if fold == "x":
      fx = n
      g.width= n
    else:
      fy = n
      g.height = n
    var points: HashSet[Point]
    for p in g.points:
      var (x, y) = p
      if x > fx: x = fx - (x - fx)
      elif y > fy: y = fy - (y - fy)
      points.incl((x, y))
    g.points = points
  result = g.points.len

proc show(g: Grid) =
  for y in 0 .. g.height:
    var line = ""
    for x in 0 .. g.width:
      line.add(if (x, y) in g.points: '#' else: '.')
    echo line

proc toGrid(xs: seq[Point]): Grid =
  result.points = xs.toHashSet
  result.width = xs.mapIt(it[0]).max
  result.height= xs.mapIt(it[1]).max

when isMainModule:
  let z = readFile("day13.txt").split("\n\n")
  let xs = z[0].split('\n').mapIt(it.split(',')).mapIt((it[0].parseInt, it[1].parseInt))
  let fs = z[1].strip.split('\n').mapIt(it.replace("fold along ", ""))
                                 .mapIt(it.split('=')).mapIt((it[0], it[1].parseInt))
  var g1, g2 = xs.toGrid
  doAssert part1(g1, fs) == 666
  doAssert part2(g2, fs) == 97

import intsets, re, sequtils, sets, strutils, tables

type
  Point = (int, int, int)
  Scanner = object
    id: int
    pos: Point
    beacons: seq[Point]

proc parse(s: string): seq[Scanner]
proc resolve(xs: var seq[Scanner])
proc distance(a, b: Point): int

proc part1(xs: seq[Scanner]): int = xs.mapIt(it.beacons.toHashSet).foldl(a + b).len

proc part2(xs: seq[Scanner]): int =
  for a in xs:
    for b in xs:
      result = max(result, distance(a.pos, b.pos))

proc `+`(a, b: Point): Point = (a[0]+b[0], a[1]+b[1], a[2]+b[2])
proc `-`(a, b: Point): Point = (a[0]-b[0], a[1]-b[1], a[2]-b[2])

proc permutations*[T](xs: openArray[T]): seq[seq[T]] =
  if xs.len > 1:
    let head = xs[0]
    let tail = xs[1 .. ^1]
    for sub in permutations(tail):
      for i in 0 .. xs.high():
        var p = @sub
        p.insert(@[head], i)
        result.add(p)
  else:
    result.add(@xs)

proc rotations(p: Point): seq[Point] =
  let perm = permutations(@[p[0], p[1], p[2]])
  let m = @[1, -1]
  for x in m:
    for y in m:
      for z in m:
        for p in perm:
          result.add((p[0] * x, p[1] * y, p[2] * z))

proc rotate(ps: seq[Point]): seq[seq[Point]] =
  var t: Table[int, seq[Point]]
  for p in ps:
    for i, per in rotations(p):
      t.mgetOrPut(i, newSeq[Point]()).add(per)
  result = t.values.toSeq

proc match(ps: seq[Point], perm: seq[seq[Point]]): (bool, Point, seq[Point]) =
  for p in perm:
    var ct: CountTable[Point]
    for a in ps:
      for b in p:
        ct.inc(a - b)
    let match = ct.largest
    if match.val > 11:
      return (true, match.key, p.mapIt(it + match.key))

proc resolve(xs: var seq[Scanner]) =
  var rotations = xs.mapIt(it.beacons.rotate)
  let all = (0 .. xs.high).toSeq.toIntSet
  var resolved = @[0].toIntSet
  var skip: HashSet[(int, int)]
  while resolved.len < xs.len:
    for i in resolved.toSeq:
      for j in all - resolved:
        if (i, j) in skip: continue
        let (m, pos, beacons) = match(xs[i].beacons, rotations[j])
        if m:
          resolved.incl(j)
          xs[j].pos = pos
          xs[j].beacons = beacons
        else:
          skip.incl((i, j))

proc parse(s: string): seq[Scanner] =
  for i, sc in s.split("\n\n").toSeq:
    var scanner = Scanner(id: i)
    let xs = sc.strip.split('\n')
    for x in xs[1 .. ^1]:
      let p = x.findAll(re"-?\d+").map(parseInt)
      scanner.beacons.add((p[0], p[1], p[2]))
    result.add(scanner)

proc distance(a, b: Point): int =
  for _, a1, b1 in fieldPairs(a, b):
    result.inc(abs(a1 - b1))

when isMainModule:
  var sc = readFile("day19.txt").parse
  sc.resolve
  doAssert part1(sc) == 342
  doAssert part2(sc) == 9668

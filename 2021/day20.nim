import sequtils, sets, strutils

type
  Point = (int, int)
  Image = object
    pixels: HashSet[Point]
    algorithm: string
  Bounds = tuple[left: int, top: int, right: int, bottom: int]

proc parse(s: string): Image
proc enhance(img: Image, count: int): Image

proc part1(img: Image): int = img.enhance(2).pixels.len
proc part2(img: Image): int = img.enhance(50).pixels.len

proc `in`(p: Point, b: Bounds): bool =
  p[0] >= b.left and p[0] <= b.right and
  p[1] >= b.top and p[1] <= b.bottom

const Deltas = @[ (-1,-1), (0,-1), (1,-1), (-1,0), (0,0), (1,0), (-1,1), (0,1), (1,1)]

proc neighbours(p: Point): seq[Point] =
  for (dx, dy) in Deltas:
    result.add((p[0] + dx, p[1] + dy))

proc findBounds(ps: HashSet[Point]): (int, int, int, int) =
  result = (int.high, int.high, -int.high, -int.high)
  for p in ps:
    let (x, y) = p
    result = (
      min(x, result[0]),
      min(y, result[1]),
      max(x, result[2]),
      max(y, result[3]),
    )

proc enhance(img: Image, count: int): Image =
  var pixels = img.pixels
  var b: Bounds
  proc tile(p: Point, n: int): char =
    if p in pixels: return '1'
    if p in b: return '0'
    # intinite pixels filp every iteration
    if n mod 2 == 0: return '1'
    return '0'
  for n in 1 .. count:
    var next: HashSet[Point]
    b = pixels.findBounds
    let (minx, miny, maxx, maxy) = b
    for x in minx-1 .. maxx+1:
      for y in miny-1 .. maxy+1:
        let p = (x, y)
        let indx = p.neighbours.mapIt(it.tile(n)).join.parseBinInt
        if img.algorithm[indx] == '1':
          next.incl(p)
    pixels = next
  result.pixels = pixels

proc parse(s: string): Image =
  let p = s.split("\n\n")
  result.algorithm = p[0].strip.multiReplace(("#","1"),(".","0"))
  let xs = p[1].strip.split('\n')
  for x in 0 .. xs[0].high:
    for y in 0 .. xs.high:
      if xs[y][x] == '#':
        result.pixels.incl((x,y))

when isMainModule:
  let img = readFile("day20.txt").parse
  doAssert part1(img) == 5503
  doAssert part2(img) == 19156

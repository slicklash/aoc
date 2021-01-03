import algorithm, intsets, sequtils, strutils, tables

type
  Pattern = seq[string]
  PatternMatrix = seq[seq[Pattern]]
  Edge = string
  Tile = object
    id: int
    pattern: Pattern
    edges: seq[Edge]

const MONSTER = @["                  # ",
                  "#    ##    ##    ###",
                  " #  #  #  #  #  #   "]
const mHeight = MONSTER.len
const mWidth = MONSTER[0].len

proc left(p: Pattern): Edge = p.mapIt(it[0]).join
proc right(p: Pattern): Edge = p.mapIt(it[^1]).join
proc top(p: Pattern): Edge = p[0]
proc bottom(p: Pattern): Edge = p[^1]
proc edges(p: Pattern): seq[Edge] =
  result = @[p.left, p.right, p.top, p.bottom]
  result = result & result.mapIt(it.reversed.join)

proc parse(text: string): seq[Tile] =
  let tiles = text.strip.split("\n\n")
  for t in tiles:
    let x = t.split('\n')
    let id = x[0].split({':', ' '})[1].parseInt
    let pat = x[1..^1]
    let tile = Tile(id: id, pattern: pat, edges: edges(pat))
    result.add(tile)

proc shrinked(p: Pattern): Pattern = p[1..^2].mapIt(it[1..^2])
proc flipped(p: Pattern): Pattern = p.mapIt(it.reversed.join)
proc rotated(p: Pattern): Pattern =
  for col in 0..p[0].high:
    var line = ""
    for row in countdown(p.high, 0):
      line.add(p[row][col])
    result.add(line)

iterator transform(p: Pattern): Pattern =
  var p = p
  for _ in 0..4:
    yield p
    yield p.flipped
    p = p.rotated

proc assemble(matrix: PatternMatrix): Pattern =
  for row in matrix:
    for col in 0..matrix[0][0].high:
      result.add(row.mapIt(it[col]).join)

proc shrink(matrix: PatternMatrix): PatternMatrix =
  for row in matrix:
    result.add(row.mapIt(it.shrinked))

proc corners(tiles: seq[Tile]): seq[Tile] =
  var pairs: Table[int, IntSet]
  for a in tiles:
    for b in tiles:
      if a.id != b.id:
        for ab in a.edges:
          if ab in b.edges:
            pairs.mgetOrPut(a.id, initIntSet()).incl(b.id)
  result = tiles.filterIt(pairs[it.id].len == 2)

proc solvePuzzle(tiles: seq[Tile]): PatternMatrix =
  var edgeTiles: Table[string, seq[int]]
  for t in tiles:
    for e in t.edges:
      edgeTiles.mgetOrPut(e, newSeq[int]()).add(t.id)

  var corner = corners(tiles)[0]
  var first = corner.pattern
  for tx in transform(first):
    if edgeTiles[tx.left].len == 1 and edgeTiles[tx.top].len == 1:
      first = tx
      break

  var row = @[first]
  var used = @[corner.id].toIntSet
  var last = first
  var sameRow = true
  while used.len < tiles.len:
    for t in tiles.filterIt(it.id notin used):
      for tx in transform(t.pattern):
        if sameRow and last.right == tx.left:
          used.incl(t.id)
          row.add(tx)
          last = tx
          if edgeTiles[tx.right].len == 1:
            result.add(row)
            row = @[]
            sameRow = false
          break
        elif not sameRow and first.bottom == tx.top:
          used.incl(t.id)
          row.add(tx)
          last = tx
          first = tx
          sameRow = true
          break

proc countMonsters(p: Pattern): int =
  for y in 0..p.high - mHeight:
    for x in 0..p[0].high - mWidth:
      block search:
        for my in 0..<mHeight:
          for mx in 0..<mWidth:
            if MONSTER[my][mx] == '#' and p[y+my][x+mx] != '#':
              break search
        inc(result)

proc part1(tiles: seq[Tile]): int = corners(tiles).foldl(a * b.id, 1)

proc part2(tiles: seq[Tile]): int =
  for tx in transform(tiles.solvePuzzle.shrink.assemble):
    result = tx.countMonsters
    if result > 0:
      return tx.join.count('#') - result * MONSTER.join.count('#')

when isMainModule:
  let tiles = parse(readFile("day20.txt"))
  doAssert part1(tiles) == 18482479935793
  doAssert part2(tiles) == 2118

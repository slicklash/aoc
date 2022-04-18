import algorithm, math, sequtils, sets, strutils, tables

const UNIQUE = {2: 1, 4: 4, 3: 7, 7: 8}.toTable

proc union(a, b: string): int = len(a.toHashSet + b.toHashSet)
proc diff(a, b: string): int = len(a.toHashSet - b.toHashSet)

proc part1(xs: seq[(seq[string], seq[string])]): int =
  for (_, output) in xs:
    result += output.filterIt(UNIQUE.hasKey(it.len)).len

proc part2(xs: seq[(seq[string], seq[string])]): int =
  for (a, b) in xs:
    var digits: Table[string, int]
    var lx: Table[int, seq[string]]
    for str in a:
      let key = str.sorted.join
      let d = UNIQUE.getOrDefault(key.len)
      if d > 0: digits[key] = d
      lx.mgetOrPut(key.len, @[]).add(key)

    let (d4, d7) = (lx[4][0], lx[3][0])

    for str in lx[6]:
      var d = 0
      if diff(str, d4) == 2: d = 9
      elif diff(str, d7) == 4: d = 6
      digits[str] = d

    for str in lx[5]:
      var d = 2
      if diff(str, d7) == 2: d = 3
      elif union(str, d4) == 6: d = 5
      digits[str] = d

    for i, str in b:
      result += digits[str.sorted.join] * 10 ^ (3 - i)

when isMainModule:
  let xs = lines("day08.txt")
            .toSeq
            .mapIt(it.split(" | "))
            .mapIt((it[0].splitWhitespace,
                    it[1].splitWhitespace))

  doAssert part1(xs) == 247
  doAssert part2(xs) == 933305

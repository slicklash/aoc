import math, sequtils, strutils

type
  Packet = object
    ver: int
    tid: int
    value: int
    sub: seq[Packet]

proc parse(s: string): Packet
proc eval(p: Packet): int

proc part1(p: Packet): int = p.ver + p.sub.map(part1).sum
proc part2(p: Packet): int = p.eval

proc parse(s: string): Packet =
  let bs = s.mapIt(($it).parseHexInt.toBin(4)).join
  var pos = 0

  proc read(n: int): string =
    result = bs[pos ..< pos + n]
    pos.inc(n)

  proc parseLiteral(): int
  proc parseOperator(): seq[Packet]

  proc parsePacket(): Packet =
    result.ver = read(3).parseBinInt
    result.tid = read(3).parseBinInt
    if result.tid == 4:
      result.value = parseLiteral()
    else:
      result.sub = parseOperator()

  proc parseLiteral(): int =
    var bits: seq[string]
    var done = false
    while not done:
      done = read(1) == "0"
      bits.add(read(4))
    result = bits.join.parseBinInt

  proc parseOperator(): seq[Packet] =
    var count, stop: int
    if read(1) == "0":
      stop = pos + read(15).parseBinInt
    else:
      count = read(11).parseBinInt
    while count > 0 or pos < stop:
      result.add(parsePacket())
      count.dec

  return parsePacket()

proc eval(p: Packet): int =
  let sub = p.sub.map(eval)
  case p.tid
    of 0: return sub.sum
    of 1: return sub.foldl(a * b)
    of 2: return sub.min
    of 3: return sub.max
    of 4: return p.value
    of 5: return if sub[0] > sub[1]: 1 else: 0
    of 6: return if sub[0] < sub[1]: 1 else: 0
    of 7: return if sub[0] == sub[1]: 1 else: 0
    else: raise newException(ValueError, "unknown tid " & $p.tid)

when isMainModule:
  let p = readFile("day16.txt").strip.parse
  doAssert part1(p) == 993
  doAssert part2(p) == 144595909277

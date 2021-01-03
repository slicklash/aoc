import sequtils, strutils

proc part1(xs: seq[string]): int =
  let timestamp = xs[0].parseInt
  let ids = xs[1].split(',').filterIt(it != "x").mapIt(it.parseInt)
  var n = timestamp
  while true:
    for id in ids:
      if n mod id == 0:
        return (n - timestamp) * id
    inc(n)

proc modInv(a0, m: int): int =
  var (a, b, x0) = (a0, m, 0)
  result = 1
  if b == 1: return
  while b > 0:
    let q = a div b
    a = a mod b
    swap a, b
    result = result - q * x0
    swap x0, result
  if a != 1:
    raise newException(ArithmeticDefect, "inverse does not exist")
  if result < 0: result += m

proc crt(a, n: openArray[int]): int =
  var prod = 1
  var sum = 0
  for x in n: prod *= x
  for i in 0 .. n.high:
    let p = prod div n[i]
    sum += a[i] * modInv(p, n[i]) * p
  result = sum mod prod

proc part2(lines: seq[string]): int =
  var a, n: seq[int]
  let xs = lines[1].split(",")
  for i, bus in xs:
    if bus != "x":
      a.add(bus.parseInt - i)
      n.add(bus.parseInt)
  result = crt(a, n)

when isMainModule:
  var lines = toSeq(lines("day13.txt"))
  doAssert part1(lines) == 4938
  doAssert part2(lines) == 230903629977901

import sequtils, strutils

type
  Pair = ref object
    level: int
    value: int
    left: Pair
    right: Pair
    parent: Pair

proc parse(s: string, level = 0): Pair
proc findLeft(p: Pair): Pair
proc findRight(p: Pair): Pair
proc reduce(p: Pair): Pair
proc magnitude(p: Pair): int
proc isLeaf(p: Pair): bool = p.left == nil
proc `$`(p: Pair): string = (if p.isLeaf: $p.value else: "[" & $p.left & "," & $p.right & "]")
proc `+`(a, b: Pair): Pair = parse("[" & $a & "," & $b & "]")

proc part1(xs: seq[string]): int = xs.mapIt(it.parse).foldl((a + b).reduce).magnitude

proc part2(xs: seq[string]): int =
  let ps = xs.mapIt(it.parse)
  for i, a in ps:
    for j, b in ps:
      if i == j: continue
      result = max(result, (a + b).reduce.magnitude)

proc findLeft(p: Pair): Pair =
  if p.parent == nil: return nil
  if p.parent.right == p: return p.parent.left
  return p.parent.findLeft

proc findRight(p: Pair): Pair =
  if p.parent == nil: return nil
  if p.parent.left == p: return p.parent.right
  return p.parent.findRight

proc addLeft(p: Pair, n: int) =
  if p.isLeaf: p.value.inc(n)
  else: p.left.addLeft(n)

proc addRight(p: Pair, n: int) =
  if p.isLeaf: p.value.inc(n)
  else: p.right.addRight(n)

proc explode(p: Pair): bool =
  if p.level == 4 and not p.isLeaf:
    let l = p.findLeft
    let r = p.findRight
    if l != nil: l.addRight(p.left.value)
    if r != nil: r.addLeft(p.right.value)
    p.right = nil
    p.left = nil
    p.value = 0
    return true
  if not p.isLeaf:
    return p.left.explode or p.right.explode

proc split(p: Pair): bool =
  if p.isLeaf and p.value > 9:
    let n = p.value div 2
    p.left = new(Pair)
    p.left.value = n
    p.left.level = p.level + 1
    p.left.parent = p
    p.right = new(Pair)
    p.right.value = p.value - n
    p.right.level = p.level + 1
    p.right.parent = p
    return true
  if not p.isLeaf:
    return p.left.split or p.right.split

proc reduce(p: Pair): Pair =
  result = parse($p)
  while result.explode or result.split:
    discard

proc magnitude (p: Pair): int =
  if p.isLeaf: return p.value
  result = 3 * p.left.magnitude + 2 * p.right.magnitude

proc parse(s: string, level = 0): Pair =
  result = new(Pair)
  result.level = level
  if ',' notin s:
    result.value = s.parseInt
    return result
  var pos = 1
  var open = 0
  for c in s[1 .. ^2]:
    if open == 0 and c == ',': break
    pos.inc
    if c == '[': open.inc
    elif c == ']': open.dec
    if open == 0 and not c.isDigit:
      break
  result.left = s[1 ..< pos].parse(level + 1)
  result.right = s[pos + 1 .. ^2].parse(level + 1)
  result.left.parent = result
  result.right.parent = result

when isMainModule:
  let xs = lines("day18.txt").toSeq
  doAssert part1(xs) == 3699
  doAssert part2(xs) == 4735

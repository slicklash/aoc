import lists, strutils, tables

proc run(cups: seq[int], rounds: int = 100, maxLabel: int = 0): SinglyLinkedNode[int] =
  var map: Table[int, SinglyLinkedNode[int]]
  var ring: SinglyLinkedRing[int]
  var maxLabel = if maxLabel > 0: maxLabel else: max(cups)

  for x in cups:
    let n = newSinglyLinkedNode[int](x)
    map[x] = n
    ring.append(n)

  if maxLabel > 10:
    for x in cups.len+1..maxLabel:
      let n = newSinglyLinkedNode[int](x)
      map[x] = n
      ring.append(n)

  var curr = ring.head

  for n in 1..rounds:
    if n mod 1_000_000 == 0:
      echo n
    var dest = curr.value - 1
    if dest < 1:
      dest = maxLabel

    var c1 = curr.next
    var c2 = c1.next
    var c3 = c2.next

    curr.next = c3.next

    let pick = @[c1.value, c2.value, c3.value]

    while dest in pick:
      dec(dest)
      if dest < 1:
        dest = maxLabel

    var next_curr = curr.next

    curr = map[dest]

    var next = curr.next
    curr.next = c1
    c1.next = c2
    c3.next = next
    curr = next_curr

  result = map[1].next

proc part1(cups: seq[int]): int =
  var curr = run(cups)
  var s = ""
  while curr.value != 1:
    s.add($curr.value)
    curr = curr.next
  result = parseInt(s)

proc part2(cups: seq[int]): int =
  let curr = run(cups, 10_000_000, 1_000_000)
  result = curr.value * curr.next.value

when isMainModule:
  doAssert part1(@[8,5,3,1,9,2,6,4,7]) == 97624853
  doAssert part2(@[8,5,3,1,9,2,6,4,7]) == 664642452305

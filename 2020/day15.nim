proc solve(input: seq[int], nth: int): int =
  var lastSpoken = newSeq[int](nth)
  for i, x in input[0..^2]:
    lastSpoken[x] = i + 1
  result = input[^1]
  for turn in input.len+1..nth:
    let number = if lastSpoken[result] > 0: turn - 1 - lastSpoken[result] else: 0
    lastSpoken[result] = turn - 1
    result = number

when isMainModule:
  doAssert solve(@[15,5,1,4,7,0], 2020) == 1259
  doAssert solve(@[15,5,1,4,7,0], 30_000_000) == 689

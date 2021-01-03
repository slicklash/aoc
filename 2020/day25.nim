proc findLoop(pub: int, subject: int = 7): int =
  var value = 1
  while value != pub:
    inc(result)
    value = value * subject mod 20201227

proc part1(pub1, pub2: int): int =
  result = 1
  for _ in 1 .. findLoop(pub1):
    result = result * pub2 mod 20201227

when isMainModule:
  doAssert part1(11562782, 18108497) == 2947148

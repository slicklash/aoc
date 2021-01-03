import math, sequtils, strutils

proc hasSum(xs: seq[int], sum: int): bool =
  for i in 0..xs.high:
    for j in i+1..xs.high:
      if xs[i] + xs[j] == sum:
        return true

proc part1(numbers: seq[int], size = 25): int =
  for i in size..numbers.high:
    if not hasSum(numbers[i-size..i], numbers[i]):
      return numbers[i]

proc part2(numbers: seq[int], target: int): int =
  for i in 0..numbers.high:
    for j in i+1..numbers.high:
      let sub = numbers[i..j]
      let sum = sub.sum
      if sum == target:
        return min(sub) + max(sub)
      if sum > target:
        break

when isMainModule:
  let numbers = toSeq(lines("day09.txt")).map(parseInt)
  doAssert part1(numbers) == 731031916
  doAssert part2(numbers, 731031916) == 93396727

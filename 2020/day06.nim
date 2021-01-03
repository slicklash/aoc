import sets, strutils

proc part1(groups: seq[string]): int =
  for group in groups:
    var answers: HashSet[char]
    for person in group.split("\n"):
      answers = answers + person.toHashSet
    result += answers.len

proc part2(groups: seq[string]): int =
  const lower = "abcdefghijklmnopqrstuvwxyz".toHashSet
  for group in groups:
    var answers = lower
    for person in group.split("\n"):
      answers = answers * person.toHashSet
    result += answers.len

when isMainModule:
  let groups = readFile("day06.txt").strip().split("\n\n")
  doAssert part1(groups) == 6885
  doAssert part2(groups) == 3550

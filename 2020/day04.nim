import re, sequtils, strutils

proc part1(xs: seq[string]): int =
  let fields = "byr,iyr,eyr,hgt,hcl,ecl,pid".split(',')
  for line in xs:
    if fields.allIt(line.contains(it)):
      inc(result)

proc part2(xs: seq[string]): int =
  let fields = @[
    re"byr:(19[2-9]\d|200[0-2])",
    re"iyr:20(1\d|20)",
    re"eyr:20(2\d|30)",
    re"hgt:(1([5-8]\d|9[0-3])cm|([5-6]\d|7[0-6])in)",
    re"hcl:#[0-9a-f]{6}",
    re"ecl:(amb|blu|brn|gry|grn|hzl|oth)",
    re"pid:\d{9}(\s|$)",
  ]
  for line in xs:
    if fields.allIt(line.contains(it)):
      inc(result)

when isMainModule:
  let lines = readFile("day04.txt").split("\n\n")
  doAssert part1(lines) == 226
  doAssert part2(lines) == 160

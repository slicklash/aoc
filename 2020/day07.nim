import re, sequtils, strutils, tables

type
  Bag = tuple[color: string, count: int]
  Graph = Table[string, seq[Bag]]

const GoldenBag = "shiny gold bag"
let REGEX_BAGS = re"(\d+)([^,.]+bag)s?"

proc hasPath(graph: Graph, start: string, target: string): bool =
  for n in graph.getOrDefault(start):
    if n.color == target or graph.hasPath(n.color, target):
      return true

iterator parseBags(str: string): (string, int)  =
  var m: array[2, string]
  for bag in str.findAll(REGEX_BAGS):
    if bag.match(REGEX_BAGS, m):
      yield (m[1].strip, m[0].parseInt)

proc parse(lines: seq[string]): Graph =
  for line in lines:
    let x = line.split("s contain ")
    for bag in parseBags(x[1]):
      result.mgetOrPut(x[0], @[]).add(bag)

proc part1(graph: Graph): int =
  for color in graph.keys:
    if graph.hasPath(color, GoldenBag):
      inc(result)

proc part2(graph: Graph, bag: string = GoldenBag): int =
  result = if bag == GoldenBag: 0 else: 1
  for (color, count) in graph.getOrDefault(bag):
    result += count * part2(graph, color)

when isMainModule:
  let graph = toSeq(lines("day07.txt")).parse()
  doAssert part1(graph) == 155
  doAssert part2(graph) == 54803

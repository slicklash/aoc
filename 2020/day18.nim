import re, sequtils, strformat, strutils, tables

let operators = {
  "+": proc (a: int, b: int): int = a + b,
  "*": proc (a: int, b: int): int = a * b}.toTable()

proc eval(exp: string): int =
  var (xs, i) = (exp.split(' '), 1)
  result = xs[0].parseInt
  while i < xs.high:
    if xs[i] in operators:
      result = operators[xs[i]](result, xs[i+1].parseInt)
      inc(i)
    inc(i)

proc foldParens(exp: string): string =
  result = exp
  while '(' in result:
    let (s, e) = result.findBounds(re"\([^()]+\)")
    if s > -1:
      result = result[0..<s] & $eval(result[s+1..<e]) & result[e+1..^1]

proc foldOp(exp: string, op: string, captureParens = false): string =
  result = exp
  let regex = if captureParens: re(fmt"\(\d+( \{op} \d+)+\)") else: re(fmt"\d+( \{op} \d+)+")
  while true:
    var (s, e) = result.findBounds(regex)
    if s == -1:
      break
    if captureParens:
      inc(s)
      dec(e)
    result = result[0..<s] & $eval(result[s..e]) & result[e+1..^1]
  result = result.replacef(re"\((\d+)\)", "$1")

proc part1(lines: seq[string]): int =
  for line in lines:
    result += line.foldParens.eval

proc part2(lines: var seq[string]): int =
  for line in mitems(lines):
    var prev: int
    while prev != line.len:
      prev = line.len
      line = line.foldOp("+").foldOp("*", true)
    result += line.eval

when isMainModule:
  var lines = toSeq(lines("day18.txt"))
  doAssert part1(lines) == 21022630974613
  doAssert part2(lines) == 169899524778212

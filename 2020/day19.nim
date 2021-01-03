import re, strutils, tables, options

type
  Rules = Table[int, string]
  RuleToRegexProc = proc(x: int): Option[string]

proc parse(text: string): (Rules, seq[string]) =
  var rules: Rules
  var messages: seq[string]
  for line in text.split("\n"):
    if ':' in line:
      let s = line.split(':')
      let key = s[0].parseInt
      rules[key] = s[1]
    else:
      messages.add(line)
  result = (rules, messages)

proc toRegex(rule: string, rules: Rules, fn: RuleToRegexProc = nil): string =
  for x in rule.split(' '):
    if '"' in x:
      return x[1..^2]
    if '|' in x:
      result = result & "|"
    elif not x.isEmptyOrWhitespace:
      let n = x.parseInt
      let regex = if fn == nil: none(string) else: fn(n)
      result &= (if regex.isSome: regex.get else: rules[n].toRegex(rules, fn))
  result = "(" & result & ")"

proc part1(rules: Rules, messages: seq[string]): int =
  let regex0 = re("^" & rules[0].toRegex(rules) & "$")
  for msg in messages:
    if msg.match(regex0):
      inc(result)

proc part2(rules: Rules, messages: seq[string]): int =
  var fn = proc(n: int): Option[string] =
    case n
    of 8:
      return some(toRegex("42", rules) & "+")
    of 11:
      let r42 = toRegex("42", rules)
      let r31 = toRegex("31", rules)
      return some("(?P<name>" & r42 & "(?&name)?" & r31 & ")")
    else: return none(string)

  let regex0 = re("^" & rules[0].toRegex(rules, fn) & "$")
  for msg in messages:
    if msg.match(regex0):
      inc(result)

when isMainModule:
  let (rules, messages) = readFile("day19.txt").parse
  doAssert part1(rules, messages) == 210
  doAssert part2(rules, messages) == 422

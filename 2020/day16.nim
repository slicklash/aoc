import intsets, math, re, tables, sequtils, strutils

type
  FieldMap = Table[string, IntSet]
  Tickets = seq[seq[int]]

proc parse(lines: seq[string]): (FieldMap, Tickets) =
  var m: array[5, string]
  for line in lines:
    if line.match(re"([^:]+): (\d+)-(\d+) or (\d+)-(\d+)", m):
      let r1 = (m[1].parseInt .. m[2].parseInt).toSeq.toIntSet
      let r2 = (m[3].parseInt .. m[4].parseInt).toSeq.toIntSet
      result[0][m[0]] = r1 + r2
    elif ',' in line:
      result[1].add(line.split(',').mapIt(it.parseInt))

proc part1(fields: FieldMap, tickets: Tickets): int =
  let validRange = toSeq(fields.values).foldl(a + b)
  result = tickets.mapIt(toSeq(it.toIntSet - validRange).sum).sum

proc part2(fields: var FieldMap, tickets: Tickets): int =
  let validRange = toSeq(fields.values).foldl(a + b)
  let tickets = tickets.filterIt((it.toIntSet - validRange).len == 0)
  var fieldValueMap: Table[int, IntSet]
  for i in 0 .. tickets[0].high:
    fieldValueMap[i] = tickets.mapIt(it[i]).toIntSet
  result = 1
  while len(fieldValueMap) > 0:
    for name, valueRange in fields:
      var match: seq[int]
      for index, fieldValues in fieldValueMap:
        if len(fieldValues - valueRange) == 0:
          match.add(index)
      if match.len == 1:
        let index = match[0]
        fields.del(name)
        fieldValueMap.del(index)
        if "departure" in name:
          result *= tickets[0][index]
        break

when isMainModule:
  var (fields, tickets) = parse(toSeq(lines("day16.txt")))
  doAssert part1(fields, tickets) == 20060
  doAssert part2(fields, tickets) == 2843534243843

import intsets, sequtils, strutils

type
  OpCode = enum
    acc, jmp, nop
  Instruction = (OpCode, int)

proc parse(lines: seq[string]): seq[Instruction] =
  for line in lines:
    let x = line.split(' ')
    let op = parseEnum[OpCode](x[0])
    let arg = x[1].parseInt
    result.add((op, arg))

proc part1(program: seq[Instruction]): (int, bool) =
  var ip, mem: int
  var seen: IntSet
  while ip notin seen and ip < program.len:
    seen.incl(ip)
    let (op, arg) = program[ip]
    case op
      of acc:
        mem += arg
        inc(ip)
      of jmp:
        ip += arg
      of nop:
        inc(ip)
  result = (mem, ip > program.high)

proc part2(program: seq[Instruction]): int =
  for i in 0..program.high:
    let (op, arg) = program[i]
    if op == acc:
      continue
    var fixed = program
    fixed[i] = ((if op == jmp: nop else: jmp), arg)
    let (value, finished) = part1(fixed)
    if finished:
      return value

when isMainModule:
  let program = toSeq(lines("day08.txt")).parse()
  doAssert part1(program)[0] == 1749
  doAssert part2(program) == 515

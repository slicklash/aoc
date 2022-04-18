import sequtils, strutils

proc solve(): seq[int]

proc part1(xs: seq[int]): int = xs.max
proc part2(xs: seq[int]): int = xs.min

let ZS = @[1,1,1,1,26,1,26,1,26,26,26,26,1,26]
let XS = @[14,11,11,14,-11,12,-1,10,-3,-4,-13,-8,13,-11]
let YS = @[12,8,7,4,4,1,10,8,12,10,15,4,10,9]
proc step(i, d, z: int): int =
  if (z mod 26) + XS[i] != d:
    result = (z div ZS[i]) * 26
    result += (d + YS[i])
  else:
    result = z div ZS[i]
#[
   push d[0] + 12
   push d[1] + 8
   push d[2] + 7
   push d[3] + 4
   pop  d[4] == d[3] + 4 - 11
   push d[5] + 1
   pop  d[6] == d[5] + 1 - 1
   push d[7] + 8
   pop  d[8] == d[7] + 8 - 3
   pop  d[9] == d[2] + 7 - 4
   pop  d[10] == d[1] + 8 - 13
   pop  d[11] == d[0] + 12 - 8
   push d[12] + 10
   pop  d[13] == d[12] + 10 - 11
]#

proc invalid(d: int): bool = d < 1 or d > 9

proc solve(): seq[int] =
  for d0 in 1 .. 9:
    let d11 = d0 + 4
    if d11.invalid: continue
    for d1 in 1 .. 9:
      let d10 = d1 - 5
      if d10.invalid: continue
      for d2 in 1 .. 9:
        let d9 = d2 + 3
        if d9.invalid: continue
        for d3 in 1 .. 9:
          let d4 = d3 - 7
          if d4.invalid: continue
          for d5 in 1 .. 9:
            let d6 = d5
            for d7 in 1 .. 9:
              let d8 = d7 + 5
              if d8.invalid: continue
              for d12 in 1 .. 9:
                let d13 = d12 - 1
                if d13.invalid: continue
                let d = @[d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13]
                let n = d.mapIt($it).join.parseInt
                result.add(n)

when isMainModule:
  let xs = solve()
  doAssert part1(xs) == 59692994994998
  doAssert part2(xs) == 16181111641521

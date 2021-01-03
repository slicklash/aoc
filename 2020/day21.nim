import algorithm, sets, sequtils, strutils, tables

type
  AllergenMap = Table[string, HashSet[string]]
  FoodList = seq[HashSet[string]]

proc parse(text: string): (FoodList, AllergenMap) =
  var foodList: FoodList
  var allergens: AllergenMap
  for l in text.strip().split('\n'):
    let xs = l.split("(contains ")
    let food = xs[0].strip.split(' ').toHashSet
    foodList.add(food)
    for a in xs[1].split(',').mapIt(it.strip(chars = {' ', ')'})):
      allergens[a] = allergens.getOrDefault(a, food) * food
  result = (foodList, allergens)

proc part1(food: FoodList, allergens: AllergenMap): int =
  let badFood = toSeq(allergens.values).foldl(a + b)
  result = food.mapIt((it - badFood).len).foldl(a + b)

proc part2(allergens: AllergenMap): string =
  var mapped: HashSet[string]
  var ingredients: seq[(string, string)]
  while mapped.len != allergens.len:
    for a, candidates in allergens:
      let diff = toSeq(candidates - mapped)
      if diff.len == 1:
        let food = diff[0]
        mapped.incl(food)
        ingredients.add((a, food))
  result = ingredients.sorted.mapIt(it[1]).join(",")

when isMainModule:
  let text = readFile("day21.txt")
  let (food, allergens) = parse(text)
  doAssert part1(food, allergens) == 2162
  doAssert part2(allergens) == "lmzg,cxk,bsqh,bdvmx,cpbzbx,drbm,cfnt,kqprv"

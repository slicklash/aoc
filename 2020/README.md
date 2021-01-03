I have used AOC problems to finally learn Nim. I am impressed with it despite some gotchas.

Day    | Problem                                                         | Notes
------ | ---------                                                       | -------------
1      | [Report Repair](https://adventofcode.com/2020/day/1)            | **Nim.** Slices are easy to read<br>`numbers[1 ..< numbers.len]`<br> `numbers[1 .. numbers.high]`<br> `numbers[1 .. ^1]`<br> coming from other languages backward index operator `^1` takes time to get used to.<br><br> The `for` statement can be used with one or two variables - very nice.<br>`for x in numbers` (items)<br>`for i, x in numbers` (pairs)
2      | [Password Philosophy](https://adventofcode.com/2020/day/2)      | **Nim.** tuple unpacking needs brackets `let (lo, hi, c, str) = rule`<br><br>I really like automatic `result` variable and [UFCS](https://en.wikipedia.org/wiki/Uniform_Function_Call_Syntax)
3      | [Toboggan Trajectory](https://adventofcode.com/2020/day/3)      | **Nim.** `foldl` template requires expression with `a` and `b` variable names. Mixed feelings. Difficult to read
4      | [Passport Processing](https://adventofcode.com/2020/day/4)      | **Nim.** `all` fails without copying loop variable, `allIt` works ¯\\_(ツ)_/¯
5      | [Binary Boarding](https://adventofcode.com/2020/day/5)          |
6      | [Custom Customs](https://adventofcode.com/2020/day/6)           | **Nim.** Built-in sets 🚀. No built in constant for lower ASCII
7      | [Handy Haversacks](https://adventofcode.com/2020/day/7)         | **Nim.** Named tuples are nice.<br><br>`re.findAll` does not capture groups, workaround:<br>`for bag in str.findAll(REGEX_BAGS):`<br>&nbsp;&nbsp;`if bag.match(REGEX_BAGS, m):`.<br><br>Got bitten by [mgetOrPut](https://nim-lang.org/docs/tables.html#mgetOrPut%2CTable%5BA%2CB%5D%2CA%2CB) accidental copy :)
8      | [Handheld Halting](https://adventofcode.com/2020/day/8)         | **Nim.** No built-in ternary operator. Love `parseEnum` and `intsets`
9      | [Encoding Error](https://adventofcode.com/2020/day/9)           |
10     | [Adapter Array](https://adventofcode.com/2020/day/10)           | **Problem**. Part2 - number of paths in a DAG<br> **Nim**. Built-in `CountTable` 🚀
11     | [Seating System](https://adventofcode.com/2020/day/11)          |
12     | [Rain Risk](https://adventofcode.com/2020/day/12)               | **Nim**. Who needs ternary operator when you can use case expression
13     | [Shuttle Search](https://adventofcode.com/2020/day/13)          | **Problem**. Part2 - needs [Chinese Remainder Theorem](https://en.wikipedia.org/wiki/Chinese_remainder_theorem)
14     | [Docking Data](https://adventofcode.com/2020/day/14)            | **Nim**. No bult-in `combinatorics` module
15     | [Rambunctious Recitation](https://adventofcode.com/2020/day/15) | **Problem**. Don't use HashMap where array is sufficient
16     | [Ticket Translation](https://adventofcode.com/2020/day/16) 💯   | **Problem**. Sets 🚀
17     | [Conway Cubes](https://adventofcode.com/2020/day/17) 💯         | **Problem**. Mult-dimensional [Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
18     | [Operation Order](https://adventofcode.com/2020/day/18)         |
19     | [Monster Messages](https://adventofcode.com/2020/day/19) 💯     | **Nim**. Built-in `Option` type.<br>**Problem**. Part2 - [recusive regex](https://www.pcre.org/original/doc/html/pcrepattern.html#SEC23)
20     | [Jurassic Jigsaw](https://adventofcode.com/2020/day/20) 💯      | Here be dragons
21     | [Allergen Assessment](https://adventofcode.com/2020/day/21) 💯  | Similar to day 16
22     | [Crab Combat](https://adventofcode.com/2020/day/22)             | **Nim**. Built-in `deque` and hashing of arrays and sequences 🚀
23     | [Crab Cups](https://adventofcode.com/2020/day/23) 💯            | **Nim**. Built-in linked lists and rings 🚀
24     | [Lobby Layout](https://adventofcode.com/2020/day/24) 💯         | **Problem**. Hexagonal [Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
25     | [Combo Breaker](https://adventofcode.com/2020/day/25)           |


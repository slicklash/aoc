#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from utils import copy_to_clipboard


def get_pots():
    with open('day12.txt', 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


@copy_to_clipboard
def part1(pots, combinations):
    for _ in range(20):
        pots = next_generation(pots, combinations)
    return sum(pots)


@copy_to_clipboard
def part2(pots, combinations):
    sums = []
    sum_diff = lambda: sums[-1] - sums[-2]
    same_diff = lambda x: all(sums[i] - sums[i - 1] == x for i in range(-3, -1))
    for _ in range(1, int(5e10)):
        pots = next_generation(pots, combinations)
        sums.append(sum(pots))
        try:
            diff = sum_diff()
            if same_diff(diff):
                break
        except IndexError:
            pass
    while sum_diff() == diff:
        sums.pop()
    return (int(5e10) - len(sums)) * diff + sums[-1]


def parse(lines):
    initial = lines[0][len('initial state: ') :]
    pots = [i for i, p in enumerate(initial) if p == '#']
    combinations = [x[:5] for x in lines[2:] if '=> #' in x]
    return pots, combinations


def next_generation(pots, combinations):
    result = []
    for pot in range(min(pots) - 2, max(pots) + 3):
        pattern = ''.join(['#' if pot + pos in pots else '.' for pos in range(-2, 3)])
        if pattern in combinations:
            result.append(pot)
    return result


def main():
    lines = [
        'initial state: #..#.#..##......###...###',
        '',
        '...## => #',
        '..#.. => #',
        '.#... => #',
        '.#.#. => #',
        '.#.## => #',
        '.##.. => #',
        '.#### => #',
        '#.#.# => #',
        '#.### => #',
        '##.#. => #',
        '##.## => #',
        '###.. => #',
        '###.# => #',
        '####. => #',
    ]
    pots, combinations = parse(lines)
    assert part1(pots, combinations) == 325

    pots, combinations = get_pots()
    assert part1(pots, combinations) == 1987
    assert part2(pots, combinations) == 1150000000358


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from itertools import accumulate, cycle

from utils import copy_to_clipboard


def get_sequence():
    with open('day01.txt', 'r') as f:
        return [int(x) for x in f.readlines()]


@copy_to_clipboard
def part1(s):
    return sum(s)


@copy_to_clipboard
def part2(s):
    seen = {0}
    for n in accumulate(cycle(s)):
        if n in seen:
            return n
        seen.add(n)
    return None


def main():
    assert part2([-1, 1]) == 0
    assert part2([3, 3, 4, -2, -4]) == 10
    assert part2([7, 7, -2, -7, -4]) == 14

    seq = get_sequence()
    assert part1(seq) == 435
    assert part2(seq) == 245


if __name__ == '__main__':
    main()

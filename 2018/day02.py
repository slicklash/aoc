#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from collections import Counter
from itertools import product

from utils import copy_to_clipboard


def get_ids():
    with open('day02.txt', 'r') as f:
        return [x.rstrip() for x in f.readlines()]


@copy_to_clipboard
def part1(ids):
    twos, threes = 0, 0
    for x in ids:
        freq = set(Counter(x).values())
        twos += 2 in freq
        threes += 3 in freq
    return twos * threes


@copy_to_clipboard
def part2(s):
    for s1, s2 in product(s, s):
        diff = [c1 for c1, c2 in zip(s1, s2) if c1 != c2]
        if len(diff) == 1:
            return s1.replace(diff[0], '')
    return None


def main():
    ids = get_ids()
    assert part1(ids) == 5727
    assert part2(ids) == 'uwfmdjxyxlbgnrotcfpvswaqh'


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from collections import Counter
from itertools import product

from utils import copy_to_clipboard


def get_claims():
    with open('day03.txt', 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


def parse(lines):
    return [[int(n) for n in re.findall(r'\d+', x)] for x in lines]


def get_claimed_ids(claims):
    ids = {}
    for cid, left, top, width, height in claims:
        for x, y in product(range(left, left + width), range(top, top + height)):
            pos = (x, y)
            claimed = ids.get(pos, None)
            ids[pos] = cid if not claimed else 'X'
    return ids.values()


@copy_to_clipboard
def part1(ids):
    return sum(x == 'X' for x in ids)


@copy_to_clipboard
def part2(claims, ids):
    claimed = Counter(ids)
    return next(cid for cid, _, __, w, h in claims if claimed[cid] == w * h)


def main():
    claims = parse(['#1 @ 1,3: 4x4', '#2 @ 3,1: 4x4', '#3 @ 5,5: 2x2'])
    ids = get_claimed_ids(claims)
    assert part1(ids) == 4
    assert part2(claims, ids) == 3

    claims = get_claims()
    ids = get_claimed_ids(claims)
    assert part1(ids) == 120408
    assert part2(claims, ids) == 1276


if __name__ == '__main__':
    main()

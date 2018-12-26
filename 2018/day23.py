#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from operator import itemgetter

from z3 import If, Int, Optimize, Sum

from utils import copy_to_clipboard


def get_bots():
    with open('day23.txt', 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


def parse(lines):
    return [tuple(int(x) for x in re.findall(r'-?\d+', line)) for line in lines]


def distance(p1, p2):
    return sum(abs(a - b) for a, b in zip(p1, p2))


def in_range(x, y, z, _range, bots):
    for b in bots:
        x2, y2, z2, _ = b
        if distance((x, y, z), (x2, y2, z2)) <= _range:
            yield b


@copy_to_clipboard
def part1():
    bots = get_bots()
    x, y, z, _range = max(bots, key=itemgetter(3))
    return sum(1 for _ in in_range(x, y, z, _range, bots))


@copy_to_clipboard
def part2():
    bots = get_bots()
    Abs = lambda val: If(val > 0, val, -val)
    x, y, z = Int('x'), Int('y'), Int('z')
    in_ranges = []
    for bot in bots:
        bx, by, bz, br = bot
        in_ranges.append(If((Abs(x - bx) + Abs(y - by) + Abs(z - bz)) <= br, 1, 0))
    opt = Optimize()
    opt.maximize(Sum(*in_ranges))
    dist = opt.minimize(Abs(x) + Abs(y) + Abs(z))
    opt.check()
    return dist.value()


def main():
    assert part1() == 326
    assert part2() == 142473501


if __name__ == '__main__':
    main()

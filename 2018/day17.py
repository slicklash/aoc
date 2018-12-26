#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re
import sys
from collections import Counter, defaultdict, namedtuple
from itertools import product
from math import inf

from utils import copy_to_clipboard

Bounds = namedtuple('Bounds', 'top left bottom right')

sys.setrecursionlimit(3000)

def get_scan_data(file_name='day17.txt'):
    with open(file_name, 'r') as f:
        return parse(x for x in f.readlines() if x.strip())


@copy_to_clipboard
def part1(grid, bounds):
    flow(grid, bounds, 500, 0)
    c = Counter()
    for x, y in product(
        range(bounds.left - 1, bounds.right + 2), range(bounds.top, bounds.bottom + 1)
    ):
        c.update(grid[x, y])
    return c['|'] + c['~'], c['~']


def flow(grid, bounds, x, y):
    if grid[x, y] != '.' or y > bounds.bottom:
        return
    grid[x, y] = '|'
    flow(grid, bounds, x, y + 1)
    if grid[x, y + 1] in '#~':
        flow(grid, bounds, x - 1, y)
        flow(grid, bounds, x + 1, y)
        left = find_wall(grid, x, y, -1)
        right = find_wall(grid, x, y, 1)
        if left and right:
            for nx in range(left + 1, right):
                grid[nx, y] = '~'


def find_wall(grid, x, y, direction):
    while not grid[x, y] in '.#':
        x += direction
    return x if grid[x, y] == '#' and grid[x - direction, y + 1] in '#~' else None


def parse(lines):
    grid = defaultdict(lambda: '.')
    for line in lines:
        xy, start, end = [int(n) for n in re.findall(r'-?\d+', line)]
        r = range(start, end + 1)
        grid.update(
            {(xy, n): '#' for n in r} if line[0] == 'x' else {(n, xy): '#' for n in r}
        )
    b = (inf, inf, -inf, -inf)
    for x, y in grid:
        b = (min(y, b[0]), min(x, b[1]), max(y, b[2]), max(x, b[3]))
    return grid, Bounds(*b)


def main():
    lines = [
        'x=495, y=2..7',
        'y=7, x=495..501',
        'x=501, y=3..7',
        'x=498, y=2..4',
        'x=506, y=1..2',
        'x=498, y=10..13',
        'x=504, y=10..13',
        'y=13, x=498..504',
    ]
    assert part1(*parse(lines)) == (57, 29)
    assert part1(*get_scan_data()) == (31934, 24790)


if __name__ == '__main__':
    main()

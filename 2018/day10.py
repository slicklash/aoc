#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re
from collections import namedtuple
from math import inf

from utils import copy_to_clipboard

Point = namedtuple('Point', 'x y vx vy')
Bounds = namedtuple('Bounds', 'x y width height')


def get_points():
    with open('day10.txt', 'r') as f:
        return [
            Point(*[int(x) for x in re.findall(r'-?\d+', line)])
            for line in f.readlines()
        ]

def move(points):
    b = (inf, inf, -inf, -inf)
    result = []
    for p in points:
        p = p._replace(x=p.x + p.vx, y=p.y + p.vy)
        result.append(p)
        b = (min(p.x, b[0]), min(p.y, b[1]), max(p.x, b[2]), max(p.y, b[3]))
    min_x, min_y, max_x, max_y = b
    return result, Bounds(min_x, min_y, max_x - min_x, max_y - min_y)


def plot(points, bounds):
    m = [['.' for x in range(bounds.width + 1)] for y in range(bounds.height + 1)]
    for p in points:
        m[p.y - bounds.y][p.x - bounds.x] = '#'
    for row in m:
        print(''.join(row))


@copy_to_clipboard
def solve(points):
    second = 0
    while True:
        second += 1
        points, bounds = move(points)
        if bounds.width < 70 and bounds.height < 15:
            print(second, bounds)
            plot(points, bounds)
            break
    return second


def main():
    '''
    RGRKHKNA
    '''
    assert solve(get_points()) == 10117


if __name__ == '__main__':
    main()

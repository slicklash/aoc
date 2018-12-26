#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re
from itertools import groupby, product
from operator import itemgetter

from utils import copy_to_clipboard


def get_coordinates():
    with open('day06.txt', 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


def parse(lines):
    return [tuple(int(x) for x in re.findall(r'\d+', line)) for line in lines]


def distance(p1, p2):
    return sum(abs(a - b) for a, b in zip(p1, p2))


@copy_to_clipboard
def part1(coordinates):
    width = max(coordinates, key=itemgetter(0))[0]
    height = max(coordinates, key=itemgetter(1))[1]
    locations = (
        p for p in product(range(width + 1), range(height + 1)) if not p in coordinates
    )
    regions = {p: [p] for p in coordinates}
    infinity = set()

    for pos in locations:
        dist = sorted([(c, distance(pos, c)) for c in coordinates], key=itemgetter(1))
        closest = next(list(g) for _, g in groupby(dist, key=itemgetter(0)))
        if len(closest) == 1:
            coordinate, _ = closest.pop()
            regions[coordinate].append(pos)
            x, y = pos
            if x == 0 or y == 0 or x == width or y == height:
                infinity.add(coordinate)

    return max(
        len(locations)
        for coordinate, locations in regions.items()
        if not coordinate in infinity
    )


@copy_to_clipboard
def part2(coordinates, region_size=10000):
    width = max(coordinates, key=itemgetter(0))[0]
    height = max(coordinates, key=itemgetter(1))[1]
    locations = (p for p in product(range(width + 1), range(height + 1)))
    return sum(
        sum([distance(pos, c) for c in coordinates]) < region_size for pos in locations
    )


def main():
    coordinates = parse(['1, 1', '1, 6', '8, 3', '3, 4', '5, 5', '8, 9'])
    assert part1(coordinates) == 17
    assert part2(coordinates, 32) == 16

    coordinates = get_coordinates()
    assert part1(coordinates) == 3882
    assert part2(coordinates) == 43852


if __name__ == '__main__':
    main()

#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

from collections import Counter, defaultdict

from utils import copy_to_clipboard

OPEN = '.'
TREE = '|'
LUMBERYARD = '#'

DELTA_X = [-1, -1, -1, 0, 0, 1, 1, 1]
DELTA_Y = [-1, 0, 1, -1, 1, -1, 0, 1]
ADJACENT = list(zip(DELTA_X, DELTA_Y))

CHANGES = [
    (TREE, lambda area, adj: area == OPEN and adj[TREE] >= 3),
    (LUMBERYARD, lambda area, adj: area == TREE and adj[LUMBERYARD] >= 3),
    (
        LUMBERYARD,
        lambda area, adj: area == LUMBERYARD
        and adj[LUMBERYARD] >= 1
        and adj[TREE] >= 1,
    ),
    (OPEN, lambda area, _: area == LUMBERYARD),
]


def get_areas(file_name='day18.txt'):
    with open(file_name, 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


@copy_to_clipboard
def part1():
    return strange_magic(n=10)


@copy_to_clipboard
def part2():
    return strange_magic(n=1000000000)


def strange_magic(n):
    grid = get_areas()
    history = defaultdict(list)
    while n:
        n -= 1
        new_grid = {}
        resources = Counter()
        for x, y in grid:
            area = change(grid, x, y)
            resources[area] += 1
            new_grid[(x, y)] = area
        total = resources[TREE] * resources[LUMBERYARD]
        previous = history.get(total, [])
        if len(previous) > 2:
            period = previous[-1] - n
            n %= period
        history[total].append(n)
        grid = new_grid
    return total


def parse(lines):
    return {(x, y): c for y, line in enumerate(lines) for x, c in enumerate(line)}


def change(grid, x, y):
    area = grid[x, y]
    adj = get_adjacent(grid, x, y)
    return next((a for a, predicate in CHANGES if predicate(area, adj)), area)


def get_adjacent(grid, x, y):
    return defaultdict(
        int,
        Counter(
            grid[x + dx, y + dy] for dx, dy in ADJACENT if (x + dx, y + dy) in grid
        ),
    )


def main():
    assert part1() == 543312
    assert part2() == 199064


if __name__ == '__main__':
    main()

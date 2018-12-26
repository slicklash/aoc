#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

from itertools import product

from utils import copy_to_clipboard

GRID_SIZE = 300


@copy_to_clipboard
def part1(serial):
    x, y, _ = solve(serial, max_square=3)
    return x, y


@copy_to_clipboard
def part2(serial):
    return solve(serial)


def solve(serial, max_square=GRID_SIZE):
    grid = get_grid(serial)
    max_total = 0
    max_size = 0
    for size in range(2, max_square + 1):
        for x, y in coordinates(size):
            try:
                total = sum(sum(grid[y + i][x : x + size]) for i in range(size))
                if total > max_total:
                    max_total, max_size = total, size
                    result = (x, y, size)
            except IndexError:
                pass
        if size - max_size > 10:
            break
    return result


def get_grid(serial):
    return [
        [power(x, y, serial) for x in range(GRID_SIZE + 1)]
        for y in range(GRID_SIZE + 1)
    ]


def power(x, y, serial):
    rack_id = x + 10
    return (rack_id * y + serial) * rack_id // 100 % 10 - 5


def coordinates(size):
    return product(range(GRID_SIZE - size + 1), range(GRID_SIZE - size + 1))


def main():
    assert part1(18) == (33, 45)
    assert part2(18) == (90, 269, 16)
    assert part1(42) == (21, 61)
    assert part2(42) == (232, 251, 12)
    assert part1(7139) == (20, 62)
    assert part2(7139) == (229, 61, 16)


if __name__ == '__main__':
    main()

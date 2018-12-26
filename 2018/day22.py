#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from functools import lru_cache
from heapq import heappop, heappush
from itertools import product

from utils import copy_to_clipboard

ROCKY, WET, NARROW = 0, 1, 2
NEITHER, CLIMBING_GEAR, TORCH = 0, 1, 2
TOOLS = {
    ROCKY: [CLIMBING_GEAR, TORCH],
    WET: [CLIMBING_GEAR, NEITHER],
    NARROW: [TORCH, NEITHER],
}

DELTA_X = [1, 0, -1, 0]
DELTA_Y = [0, 1, 0, -1]
ADJACENT = list(zip(DELTA_X, DELTA_Y))


@copy_to_clipboard
def part1(depth, target):
    return sum(get_regions(depth, target).values())


@copy_to_clipboard
def part2(depth, target):
    grid = get_regions(depth, target, 14)
    queue = [(0, 0, 0, TORCH)]
    visited = set()
    while queue:
        total_minutes, x, y, current_tool = heappop(queue)
        pos_and_tool = (x, y, current_tool)
        if pos_and_tool == (target[0], target[1], TORCH):
            return total_minutes
        if pos_and_tool in visited:
            continue
        visited.add(pos_and_tool)
        for nx, ny, minutes, tool in adjacent(grid, x, y, current_tool):
            if (nx, ny, tool) not in visited:
                heappush(queue, (total_minutes + minutes, nx, ny, tool))


def get_regions(depth, target, delta_beyond_target=0):
    return {
        (x, y): erosion_level(x, y, depth, target) % 3
        for x, y in product(
            range(0, target[0] + delta_beyond_target + 1),
            range(0, target[1] + delta_beyond_target + 1),
        )
    }


def adjacent(grid, x, y, current_tool):
    for dx, dy in ADJACENT:
        nx, ny = x + dx, y + dy
        if (nx, ny) not in grid:
            continue
        region_type = grid[nx, ny]
        for tool in TOOLS[region_type]:
            yield nx, ny, 1 if tool == current_tool else 8, tool


@lru_cache(None)
def erosion_level(x, y, depth, target):
    return (geo_index(x, y, depth, target) + depth) % 20183


def geo_index(x, y, d, t):
    if (x, y) in [(0, 0), t]:
        return 0
    if y == 0:
        return x * 16807
    if x == 0:
        return y * 48271
    return erosion_level(x - 1, y, d, t) * erosion_level(x, y - 1, d, t)


def main():
    assert part1(510, (10, 10)) == 114
    assert part1(9171, (7, 721)) == 5786

    assert part2(510, (10, 10)) == 45
    assert part2(9171, (7, 721)) == 986


if __name__ == '__main__':
    main()

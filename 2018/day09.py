#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re
from collections import defaultdict, deque

from utils import copy_to_clipboard


def get_game_setup():
    with open('day09.txt', 'r') as f:
        return [int(x) for x in re.findall(r'\d+', f.read())]


def solve(player_count, marble_count):
    circle = deque([0])
    scores = defaultdict(int)
    for n in range(1, marble_count + 1):
        if n % 23 == 0:
            circle.rotate(-7)
            scores[n % player_count] += n + circle.pop()
        else:
            circle.rotate(2)
            circle.append(n)
    return max(scores.values())


@copy_to_clipboard
def part1(player_count, marble_count):
    return solve(player_count, marble_count)


@copy_to_clipboard
def part2(player_count, marble_count):
    return solve(player_count, marble_count * 100)


def main():
    assert part1(10, 1618) == 8317
    assert part1(13, 7999) == 146373

    player_count, marble_count = get_game_setup()
    assert part1(player_count, marble_count) == 399645
    assert part2(player_count, marble_count) == 3352507536


if __name__ == '__main__':
    main()

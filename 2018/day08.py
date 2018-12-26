#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re

from utils import copy_to_clipboard


def get_nodes():
    with open('day08.txt', 'r') as f:
        return [int(n) for n in re.findall(r'\d+', f.read())]


def check_next(nodes):
    child_count, meta_count = nodes[:2]
    nodes = nodes[2:]
    total_sum = 0
    children_sums = {}

    for i in range(child_count):
        child_total, child_sum, nodes = check_next(nodes)
        children_sums[i + 1] = child_sum
        total_sum += child_total

    meta = nodes[:meta_count]
    meta_sum = sum(meta)
    total_sum += meta_sum

    return (
        total_sum,
        sum(children_sums.get(i, 0) for i in meta) if child_count else meta_sum,
        nodes[meta_count:],
    )


@copy_to_clipboard
def part1(nodes):
    total_sum, _, __ = check_next(nodes)
    return total_sum


@copy_to_clipboard
def part2(nodes):
    _, root_sum, __ = check_next(nodes)
    return root_sum


def main():
    nodes = [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]
    assert part1(nodes) == 138
    assert part2(nodes) == 66

    nodes = get_nodes()
    assert part1(nodes) == 42254
    assert part2(nodes) == 25007


if __name__ == '__main__':
    main()

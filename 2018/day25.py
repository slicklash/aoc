#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re
from collections import defaultdict
from itertools import product

from utils import copy_to_clipboard


def get_points(file_name='day25.txt'):
    with open(file_name, 'r') as f:
        parse = lambda line: tuple([int(x) for x in re.findall(r'-?\d+', line)])
        return [parse(x.rstrip()) for x in f.readlines()]


def distance(p1, p2):
    return sum(abs(a - b) for a, b in zip(p1, p2))


@copy_to_clipboard
def part1():
    points = get_points()
    graph = defaultdict(set)
    for p1, p2 in product(points, points):
        if distance(p1, p2) <= 3:
            graph[p1].add(p2)
    return len(connected_component_subgraphs(graph))


def connected_component_subgraphs(graph):
    visited = set()

    def subgraph(node, visited):
        visited.add(node)
        connected = [node]
        for neighbour in graph[node]:
            if not neighbour in visited:
                connected.extend(subgraph(neighbour, visited))
        return connected

    return [subgraph(node, visited) for node in graph if not node in visited]


def main():
    assert part1() == 346


if __name__ == '__main__':
    main()

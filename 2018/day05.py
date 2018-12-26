#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from string import ascii_lowercase, ascii_uppercase

from utils import copy_to_clipboard

PAIRS = list(zip(ascii_lowercase, ascii_uppercase))


def get_polymer():
    with open('day05.txt', 'r') as f:
        return f.read().rstrip()


# @copy_to_clipboard
def part1(polymer):
    length = 0
    while len(polymer) != length:
        length = len(polymer)
        for l, u in PAIRS:
            polymer = polymer.replace(l + u, '').replace(u + l, '')
    return length


@copy_to_clipboard
def part2(polymer):
    return min(
        part1(polymer.replace(c, '').replace(c.upper(), '')) for c in ascii_lowercase
    )


def main():
    polymer = 'dabAcCaCBAcCcaDA'
    assert part1(polymer) == 10
    assert part2(polymer) == 4

    polymer = get_polymer()
    assert part1(polymer) == 10384
    assert part2(polymer) == 5412


if __name__ == '__main__':
    main()

#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

from collections import deque, namedtuple
from itertools import product

from utils import copy_to_clipboard

Cart = namedtuple('Cart', 'movement turns moved')
Movement = namedtuple('Movement', 'dx dy left right, take_left')

MOVEMENTS = {
    '>': Movement(dx=1, dy=0, left='^', right='v', take_left='/'),
    '<': Movement(dx=-1, dy=0, left='v', right='^', take_left='/'),
    'v': Movement(dx=0, dy=1, left='>', right='<', take_left='\\'),
    '^': Movement(dx=0, dy=-1, left='<', right='>', take_left='\\'),
}


class TrackGrid(dict):
    def __init__(self):
        super().__init__()
        self.width = 0
        self.height = 0


def get_grid(file_name='day13.txt'):
    with open(file_name, 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


@copy_to_clipboard
def part1(tracks, carts):
    return tick(tracks, carts, report_first_crash=True)


@copy_to_clipboard
def part2(tracks, carts):
    return tick(tracks, carts)


def tick(tracks, carts, report_first_crash=False):
    while len(carts) > 1:
        carts = {pos: c._replace(moved=False) for pos, c in carts.items()}
        for y, x in product(range(tracks.height), range(tracks.width)):
            pos = (x, y)
            if not pos in carts or carts[pos].moved:
                continue
            cart = carts.pop(pos, None)
            m = MOVEMENTS[cart.movement]
            pos = (x + m.dx, y + m.dy)

            if pos in carts:
                if report_first_crash:
                    return pos
                carts.pop(pos, None)
                continue

            track = tracks.get(pos, '').strip()
            change_movement = None

            if '+' in track:
                take_turn = cart.turns[0]
                cart.turns.rotate(-1)
                if take_turn != '-':
                    change_movement = m.left if take_turn == '<' else m.right
            elif track in ['/', '\\']:
                change_movement = m.left if m.take_left == track else m.right

            carts[pos] = cart._replace(
                movement=change_movement or cart.movement, moved=True
            )
    return next(iter(carts.keys()))


def parse(lines):
    tracks, carts = TrackGrid(), {}
    for y, line in enumerate(lines):
        for x, cell in enumerate(line):
            if cell in '><v^':
                carts[x, y] = Cart(movement=cell, turns=deque('<->'), moved=False)
                tracks[x, y] = '-' if cell in '><' else '|'
            else:
                tracks[x, y] = cell
    tracks.width = max(len(x) for x in lines)
    tracks.height = len(lines)
    return tracks, carts


def main():
    lines = [
        '/->-\\',
        '|   |  /----\\',
        '| /-+--+-\\  |',
        '| | |  | v  |',
        '\\-+-/  \\-+--/',
        '  \\------/',
    ]
    assert part1(*parse(lines)) == (7, 3)

    lines = [
        '/>-<\\  ',
        '|   |  ',
        '| /<+-\\',
        '| | | v',
        '\\>+</ |',
        '  |   ^',
        '  \\<->/',
    ]
    assert part2(*parse(lines)) == (6, 4)

    assert part1(*get_grid()) == (40, 90)
    assert part2(*get_grid()) == (65, 81)


if __name__ == '__main__':
    main()

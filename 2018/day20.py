#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from math import inf

from utils import copy_to_clipboard

DELTAS = {'W': (-1, 0), 'E': (1, 0), 'N': (0, -1), 'S': (0, 1)}


def get_regex(file_name='day20.txt'):
    with open(file_name, 'r') as f:
        return f.read().strip()


@copy_to_clipboard
def part1(regex):
    rooms = walk(regex)
    return max(rooms.values())


@copy_to_clipboard
def part2(regex):
    rooms = walk(regex)
    return sum(x >= 1000 for x in rooms.values())


def walk(regex):
    pos, distance, grid = (0, 0), 0, {(0, 0): 'X'}
    branch_start, branch_distance, stack = pos, distance, []
    room_distance = {}
    for c in regex[1:-1]:
        if c == '(':
            stack.append((branch_start, branch_distance, pos, distance))
            branch_start, branch_distance = pos, distance
        elif c == '|':
            pos, distance = branch_start, branch_distance
        elif c == ')':
            branch_start, branch_distance, pos, distance = stack.pop()
        else:
            dx, dy = DELTAS[c]
            grid[pos[0] + dx, pos[1] + dy] = '|' if dy == 0 else '-'
            pos = (pos[0] + dx * 2, pos[1] + dy * 2)
            grid[pos] = '.'
            distance += 1
            room_distance[pos] = min(distance, room_distance.get(pos, inf))
    return room_distance


def main():
    assert part1('^WNE$') == 3
    assert part1('^ENWWW(NEEE|SSE(EE|N))$') == 10
    assert part1('^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$') == 18
    assert part1('^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$') == 23
    assert (
        part1('^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$') == 31
    )
    assert part1(get_regex()) == 4274
    assert part2(get_regex()) == 8547


if __name__ == '__main__':
    main()

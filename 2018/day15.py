#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import logging
from collections import namedtuple
from itertools import count, product

from utils import copy_to_clipboard

Cell = namedtuple('Cell', 'value hp')
DELTA_X = [0, -1, 1, 0]
DELTA_Y = [-1, 0, 0, 1]
READING_ORDER = list(zip(DELTA_X, DELTA_Y))


class Grid(dict):
    def __init__(self, lines):
        super().__init__()
        for y, line in enumerate(lines):
            for x, value in enumerate(line):
                self[x, y] = Cell(value, hp=200)
        self.width = len(lines[0])
        self.height = len(lines)


class DeadElfError(Exception):
    pass


def get_lines(file_name='day15.txt'):
    with open(file_name, 'r') as f:
        return [x.rstrip() for x in f.readlines()]


def parse(lines):
    return Grid(lines)


@copy_to_clipboard
def part1(grid, **kwargs):
    rounds = 0
    elf_power = kwargs.get('elf_power', 3)
    power = {'G': 3, 'E': elf_power}
    raise_error = kwargs.get('raise_error', False)

    while True:
        logging.debug(
            'After %d rounds, power: G = %d, E = %d', rounds, power['G'], elf_power
        )
        get_winner(grid)
        moved = set()

        for y, x in product(range(grid.height), range(grid.width)):
            pos = (x, y)
            cell = grid[pos]
            if cell.value in '.#' or pos in moved:
                continue

            target_team = 'E' if cell.value == 'G' else 'G'
            has_targets = any(c.value == target_team for c in grid.values())
            if not has_targets:
                return get_outcome(rounds, grid, raise_error)

            if attack(grid, pos, target_team, power[cell.value], raise_error):
                continue

            moved_to = move(grid, pos, target_team)
            if moved_to:
                moved.add(moved_to)
                attack(grid, moved_to, target_team, power[cell.value], raise_error)

        rounds += 1


def part2(lines):
    for power in count(4):
        try:
            return part1(Grid(lines), elf_power=power, raise_error=True)
        except DeadElfError:
            pass


def get_outcome(rounds, grid, raise_error):
    winner_team, alive = get_winner(grid)
    if winner_team == 'G' and raise_error:
        raise DeadElfError
    return rounds, sum(x[1].hp for x in alive) * rounds


def attack(grid, pos, target_team, attack_power, raise_error=False):
    target = choose_lowest_hp_target(grid, pos, target_team)
    if not target:
        return False
    pos, cell = target
    cell = cell._replace(hp=cell.hp - attack_power)
    if cell.hp < 1 and target_team == 'E' and raise_error:
        raise DeadElfError
    grid[pos] = cell if cell.hp > 0 else Cell('.', 200)
    return True


def move(grid, pos, target_team):
    target, path = choose_closet_target(grid, pos, target_team)
    if not target:
        return None
    move_to = path[0]
    grid[move_to] = grid[pos]
    grid[pos] = Cell('.', 200)
    return move_to


def is_valid(grid, position, valid_values):
    return position in grid and grid[position].value in valid_values


def choose_lowest_hp_target(grid, start, target_team):
    x, y = start
    current = []
    for dx, dy in READING_ORDER:
        adjacent_pos = (x + dx, y + dy)
        if is_valid(grid, adjacent_pos, target_team):
            current.append((adjacent_pos, grid.get(adjacent_pos)))
    return min(current, key=lambda x: x[1].hp) if current else None


def choose_closet_target(grid, start, target_team):
    positions = (
        (x, y)
        for y, x in product(range(grid.height), range(grid.width))
        if grid[x, y].value == target_team
    )
    targets = {}
    for x, y in positions:
        path = shortest_path(grid, start, (x, y), ['.', target_team])
        if path:
            targets[x, y] = path[1:]
    if not targets:
        return None, None
    pos = min(targets, key=lambda k: len(targets[k]))
    return pos, targets[pos]


def shortest_path(grid, start, end, passable_values):
    queue = [(start, [start])]
    visited = set()
    while queue:
        pos, path = queue.pop(0)
        visited.add(pos)
        for dx, dy in READING_ORDER:
            next_pos = (pos[0] + dx, pos[1] + dy)
            if not is_valid(grid, next_pos, passable_values) or next_pos in visited:
                continue
            new_path = path + [next_pos]
            if next_pos == end:
                return new_path
            visited.add(next_pos)
            queue.append((next_pos, new_path))
    return []


def get_winner(grid):
    elves, goblins = [], []
    for y in range(grid.height):
        line, hp = '', []
        for x in range(grid.width):
            pos = (x, y)
            cell = grid[pos]
            line += cell.value
            if cell.value == 'E':
                elves.append((pos, cell))
            elif cell.value == 'G':
                goblins.append((pos, cell))
            if cell.value in 'GE':
                hp.append('{}({})'.format(cell.value, cell.hp))
        line += ' ' + ', '.join(hp)
        logging.info(line)
    if not elves:
        return 'G', goblins
    if not goblins:
        return 'E', elves
    return None, None


def main():

    lines = [
        '#######',
        '#G..#E#',
        '#E#E.E#',
        '#G.##.#',
        '#...#E#',
        '#...E.#',
        '#######',
    ]
    assert part1(parse(lines)) == (37, 36334)

    lines = [
        '#######',
        '#.G...#',
        '#...EG#',
        '#.#.#G#',
        '#..G#E#',
        '#.....#',
        '#######',
    ]
    assert part1(parse(lines)) == (47, 27730)

    lines = [
        '#######',
        '#E..EG#',
        '#.#G.E#',
        '#E.##E#',
        '#G..#.#',
        '#..E#.#',
        '#######',
    ]
    assert part1(parse(lines)) == (46, 39514)

    lines = [
        '#######',
        '#E.G#.#',
        '#.#G..#',
        '#G.#.G#',
        '#G..#.#',
        '#...E.#',
        '#######',
    ]
    assert part1(parse(lines)) == (35, 27755)

    lines = [
        '#######',
        '#.E...#',
        '#.#..G#',
        '#.###.#',
        '#E#G#G#',
        '#...#G#',
        '#######',
    ]
    assert part1(parse(lines)) == (54, 28944)

    lines = [
        '#########',
        '#G......#',
        '#.E.#...#',
        '#..##..G#',
        '#...##..#',
        '#...#...#',
        '#.G...G.#',
        '#.....G.#',
        '#########',
    ]
    assert part1(parse(lines)) == (20, 18740)

    lines = [
        '#######',
        '#.G...#',
        '#...EG#',
        '#.#.#G#',
        '#..G#E#',
        '#.....#',
        '#######',
    ]
    assert part2(lines) == (29, 4988)

    lines = [
        '#######',
        '#E..EG#',
        '#.#G.E#',
        '#E.##E#',
        '#G..#.#',
        '#..E#.#',
        '#######',
    ]
    assert part2(lines) == (33, 31284)

    assert part1(parse(get_lines())) == (80, 220480)

    assert part2(get_lines()) == (37, 53576)


if __name__ == '__main__':
    level = logging.DEBUG
    logging.basicConfig(level=logging.DEBUG, format='%(message)s')
    main()

#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re
from copy import deepcopy
from itertools import count

from utils import copy_to_clipboard


def get_lines(file_name='day24.txt'):
    with open(file_name, 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


class Group(object):
    attrs = 'system no units hp weak_to immune_to dmg dmg_type initiative'

    def __init__(self, *args):
        for i, attr in enumerate(self.attrs.split(' ')):
            setattr(self, attr, args[i])
        self.id = self.system + str(self.no)

    @property
    def power(self):
        return self.units * self.dmg


def fight(system1, system2):
    groups = sorted(system1 + system2, key=lambda g: (-g.power, -g.initiative))
    targets = select_targets(groups)
    groups = sorted(groups, key=lambda g: -g.initiative)
    killed = 0
    for attacker in groups:
        target = targets.get(attacker.id)
        if not target:
            continue
        kill = min(calc_dmg(attacker, target) // target.hp, target.units)
        target.units -= kill
        killed += kill
    return (
        [g for g in system1 if g.units],
        [g for g in system2 if g.units],
        killed > 0,
    )


@copy_to_clipboard
def part1(system1, system2):
    while system1 and system2:
        system1, system2, _ = fight(system1, system2)
    return sum(g.units for g in system2)


@copy_to_clipboard
def part2(_system1, _system2):
    for boost in count(1):
        system1 = deepcopy(_system1)
        system2 = deepcopy(_system2)
        for g in system1:
            g.dmg += boost
        killed = True
        while killed and system1 and system2:
            system1, system2, killed = fight(system1, system2)
        if system1 and not system2:
            return sum(g.units for g in system1)


def calc_dmg(attacker, defender):
    return (
        attacker.power * 2 if attacker.dmg_type in defender.weak_to else attacker.power
    )


def select_targets(groups):
    targets = {}
    chosen = set()
    for g in groups:
        target = select_target(g, groups, chosen)
        if not target:
            continue
        targets[g.id] = target
        chosen.add(target.id)
    return targets


def select_target(attacker, defenders, chosen):
    targets = sorted(
        [
            (-calc_dmg(attacker, d), -d.power, -d.initiative, d)
            for d in defenders
            if attacker.dmg_type not in d.immune_to
            and d.system != attacker.system
            and not d.id in chosen
        ]
    )
    return targets[0][3] if targets else None


def parse(lines):
    p = lines.index('Infection:')
    system1 = [
        parse_group('Immune System', n, line) for n, line in enumerate(lines[1 : p - 1])
    ]
    system2 = [
        parse_group('Infection', n, line) for n, line in enumerate(lines[p + 1 :])
    ]
    return system1, system2


def parse_group(system, n, line):
    units, hp, dmg, initiative = [int(x) for x in re.findall(r'\d+', line)]
    weak_to, immune_to = [], []
    dmg_type = line[line.index('does') :].split(' ')[2]
    if '(' in line:
        specs = line[line.index('(') + 1 : line.index(')')].split(';')
        for s in specs:
            if 'weak' in s:
                weak_to = [x.strip() for x in s.replace('weak to', '').split(',')]
            else:
                immune_to = [x.strip() for x in s.replace('immune to', '').split(',')]
    return Group(system, n, units, hp, weak_to, immune_to, dmg, dmg_type, initiative)


def main():
    lines = [
        'Immune System:',
        '17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2',
        '989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3',
        '',
        'Infection:',
        '801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1',
        '4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4',
    ]
    assert part1(*parse(lines)) == 5216
    assert part2(*parse(lines)) == 51

    assert part1(*get_lines()) == 26868
    assert part2(*get_lines()) == 434


if __name__ == '__main__':
    main()

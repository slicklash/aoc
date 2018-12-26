#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re

from utils import copy_to_clipboard


def read_manual(file_name='day16.txt'):
    with open(file_name, 'r') as f:
        lines = f.readlines()
    parse = lambda line: [int(x) for x in re.findall(r'\d+', line)]
    samples = []
    while lines:
        if 'Before' in lines[0]:
            before, instruction, after = [parse(x) for x in lines[0:3]]
            samples.append((before, instruction, after))
            lines = lines[4:]
        else:
            lines = lines[2:]
            test_code = [parse(x) for x in lines]
            break
    return samples, test_code


def assign(registers, index, value):
    registers[index] = value
    return registers


OPERATIONS = {
    'addr': lambda r, A, B, C: assign(r, C, r[A] + r[B]),
    'addi': lambda r, A, B, C: assign(r, C, r[A] + B),
    'mulr': lambda r, A, B, C: assign(r, C, r[A] * r[B]),
    'muli': lambda r, A, B, C: assign(r, C, r[A] * B),
    'banr': lambda r, A, B, C: assign(r, C, r[A] & r[B]),
    'bani': lambda r, A, B, C: assign(r, C, r[A] & B),
    'borr': lambda r, A, B, C: assign(r, C, r[A] | r[B]),
    'bori': lambda r, A, B, C: assign(r, C, r[A] | B),
    'setr': lambda r, A, B, C: assign(r, C, r[A]),
    'seti': lambda r, A, B, C: assign(r, C, A),
    'gtir': lambda r, A, B, C: assign(r, C, A > r[B]),
    'gtri': lambda r, A, B, C: assign(r, C, r[A] > B),
    'gtrr': lambda r, A, B, C: assign(r, C, r[A] > r[B]),
    'eqir': lambda r, A, B, C: assign(r, C, A == r[B]),
    'eqri': lambda r, A, B, C: assign(r, C, r[A] == B),
    'eqrr': lambda r, A, B, C: assign(r, C, r[A] == r[B]),
}


@copy_to_clipboard
def part1(samples):
    return sum(len(get_fitting_operations(s)) > 2 for s in samples)


@copy_to_clipboard
def part2(samples, test_code):
    operations = map_operations(samples)
    registers = [0, 0, 0, 0]
    for instruction in test_code:
        opcode, A, B, C = instruction
        operations[opcode](registers, A, B, C)
    return registers[0]


def get_fitting_operations(sample):
    before, instruction, after = sample
    _, A, B, C = instruction
    return [k for k, op in OPERATIONS.items() if op(before.copy(), A, B, C) == after]


def map_operations(samples):
    operations = {}
    mapped = set()
    while len(mapped) != len(OPERATIONS):
        for sample in samples:
            opcode = sample[1][0]
            if opcode in operations:
                continue
            name, *rest = [
                n for n in get_fitting_operations(sample) if n not in mapped
            ] or [None]
            if name and not rest:
                operations[opcode] = OPERATIONS[name]
                mapped.add(name)
    return operations


def main():
    samples, test_code = read_manual()
    assert part1(samples) == 596
    assert part2(samples, test_code) == 554


if __name__ == '__main__':
    main()

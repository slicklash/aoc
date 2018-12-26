#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

import re

from utils import copy_to_clipboard


def read_instructions(file_name='day19.txt'):
    with open(file_name, 'r') as f:
        lines = f.readlines()
    ip = int(re.search(r'\d+', lines[0]).group(0))
    lines = lines[1:]
    instructions = []
    for line in lines:
        op = line[:4]
        nums = [int(x) for x in re.findall(r'\d+', line)]
        instructions.append((op, *nums))
    return ip, instructions


def assign(registers, index, value):
    registers[index] = value
    return registers


OPERATIONS = {
    'addr': (lambda r, A, B, C: assign(r, C, r[A] + r[B]), 'C = A + B'),
    'addi': (lambda r, A, B, C: assign(r, C, r[A] + B), 'C = A + b'),
    'mulr': (lambda r, A, B, C: assign(r, C, r[A] * r[B]), 'C = A * B'),
    'muli': (lambda r, A, B, C: assign(r, C, r[A] * B), 'C = A * b'),
    'banr': (lambda r, A, B, C: assign(r, C, r[A] & r[B]), 'C = A and B'),
    'bani': (lambda r, A, B, C: assign(r, C, r[A] & B), 'C = A & b'),
    'borr': (lambda r, A, B, C: assign(r, C, r[A] | r[B]), 'C = A | B'),
    'bori': (lambda r, A, B, C: assign(r, C, r[A] | B), 'C = A or b'),
    'setr': (lambda r, A, _, C: assign(r, C, r[A]), 'C = A'),
    'seti': (lambda r, A, _, C: assign(r, C, A), 'C = a'),
    'gtir': (lambda r, A, B, C: assign(r, C, int(A > r[B])), 'C = a > B'),
    'gtri': (lambda r, A, B, C: assign(r, C, int(r[A] > B)), 'C = A > b'),
    'gtrr': (lambda r, A, B, C: assign(r, C, int(r[A] > r[B])), 'C = A > B'),
    'eqir': (lambda r, A, B, C: assign(r, C, int(A == r[B])), 'C = a == B'),
    'eqri': (lambda r, A, B, C: assign(r, C, int(r[A] == B)), 'C = A == b'),
    'eqrr': (lambda r, A, B, C: assign(r, C, int(r[A] == r[B])), 'C = A == B'),
    'modr': (lambda r, A, B, C: assign(r, C, r[A] % r[B]), 'C = A % B'),
    'divri': (lambda r, A, B, C: assign(r, C, r[A] // B), 'C = A / B'),
}


@copy_to_clipboard
def part1(ip_reg, instructions):
    registers = [0, 0, 0, 0, 0, 0]
    while True:
        try:
            run_instruction(ip_reg, instructions, registers)
        except IndexError:
            return registers[0]

@copy_to_clipboard
def part2(ip_reg, instructions):
    registers = [1, 0, 0, 0, 0, 0]
    instructions[1] = ('addi', 4, 1, 4)
    instructions[2] = ('modr', 5, 4, 3)
    instructions[3] = ('eqri', 3, 0, 3)
    instructions[4] = ('addr', 2, 3, 2)
    instructions[5] = ('seti', 0, 0, 2)
    instructions[6] = ('addr', 0, 4, 0)
    instructions[7] = ('eqrr', 4, 5, 3)
    instructions[8] = ('addr', 2, 3, 2)
    instructions[9] = ('seti', 0, 0, 2)
    instructions[10] = ('seti', 15, 0, 2)
    while True:
        try:
            run_instruction(ip_reg, instructions, registers)
        except IndexError:
            return registers[0]


def run_instruction(ip_reg, instructions, registers):
    ip = registers[ip_reg]
    op, A, B, C = instructions[ip]
    fn, _ = OPERATIONS[op]
    fn(registers, A, B, C)
    registers[ip_reg] += 1


def main():
    assert part1(*read_instructions('day19.txt')) == 1140
    assert part2(*read_instructions('day19.txt')) == 12474720

if __name__ == '__main__':
    main()

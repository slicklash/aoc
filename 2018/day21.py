#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-

from day19 import read_instructions, run_instruction
from utils import copy_to_clipboard


@copy_to_clipboard
def part1(ip_reg, instructions):
    registers = [0, 0, 0, 0, 0, 0]
    instructions[24] = ('divri', 4, 256, 1)
    instructions[28] = ('seti', 100, 0, 2)
    while True:
        try:
            run_instruction(ip_reg, instructions, registers)
        except IndexError:
            return registers[3]

@copy_to_clipboard
def part2(ip_reg, instructions):
    registers = [0, 0, 0, 0, 0, 0]
    instructions[24] = ('divri', 4, 256, 1)
    instructions[28] = ('seti', 100, 0, 2)
    seen, prev = set(), 0
    while True:
        try:
            run_instruction(ip_reg, instructions, registers)
        except IndexError:
            k = registers[3]
            if k in seen:
                return prev
            seen.add(k)
            prev = k
            registers[ip_reg] = 6


def main():
    assert part1(*read_instructions('day21.txt')) == 11474091
    assert part2(*read_instructions('day21.txt')) == 4520776


if __name__ == '__main__':
    main()

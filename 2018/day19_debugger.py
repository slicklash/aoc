#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re

from day19 import OPERATIONS, read_instructions, run_instruction
from utils import green


def run(ip_reg, instructions):
    registers = [0, 0, 0, 0, 0, 0]
    # instructions[24] = ('divri', 4, 256, 1)
    # instructions[29] = ('seti', 100, 0, 2)
    # instructions[1] = ('addi', 4, 1, 4)
    # instructions[2] = ('modr', 5, 4, 3)
    # instructions[3] = ('eqri', 3, 0, 3)
    # instructions[4] = ('addr', ip_reg, 3, ip_reg)
    # instructions[5] = ('seti', 0, 0, ip_reg)
    # instructions[6] = ('addr', 0, 4, 0)
    # instructions[7] = ('eqrr', 4, 5, 3)
    # instructions[8] = ('addr', ip_reg, 3, ip_reg)
    # instructions[9] = ('seti', 0, 0, ip_reg)
    # instructions[10] = ('seti', 15, 0, ip_reg)
    debug = False
    bp = 0
    s = ''
    while True:
        os.system('clear')
        debug = debug or registers[ip_reg] == bp
        show_ui(ip_reg, instructions, registers, s)
        if debug:
            s = input()
            if '=' in s:
                reg, v = s.split('=')
                reg = int(reg)
                v = int(v)
                registers[reg] = v
            elif s == 'c':
                debug = False
        try:
            run_instruction(ip_reg, instructions, registers)
            if registers[ip_reg] == bp:
                s = 'Found ' + str(registers[3])
                debug = True
        except IndexError:
            registers[1] = 0
            registers[ip_reg] = 6


REGISTER_NAMES = 'ijmknp'


def show_ui(ip_reg, instructions, registers, cmd):
    print('cmd = ', cmd)
    for i, x in enumerate(REGISTER_NAMES):
        if i != ip_reg:
            print(f'r{i} {x} = {registers[i]}')
    print(f'IP = {registers[ip_reg]}')

    lines, labels = annotate(ip_reg, instructions)

    for i, line in enumerate(lines):
        pointer = '->' if i == registers[ip_reg] else ''
        if i in labels:
            print(f'L{i}:')
        line = f'{pointer:2} {i:02}: {line}'
        if pointer:
            print(green(line))
        else:
            print(line)


def annotate(ip_reg, instructions):
    def name(r):
        if r > len(REGISTER_NAMES) - 1:
            return str(r)
        return REGISTER_NAMES[r] if r != ip_reg else 'IP'

    lines = []
    labels = set()

    for i, ins in enumerate(instructions):
        op, A, B, C = ins
        _, text = OPERATIONS[op]
        text = (
            text.replace('C', name(C))
            .replace('A', name(A))
            .replace('a', str(A))
            .replace('B', name(B))
            .replace('b', str(B))
        )
        text = re.sub(r'(\w+) = \1 ([^=>])', r'\1 \2=', text)
        label = ''
        condition = ''

        jump = re.match(r'IP = (\d+)', text)
        if jump:
            label = int(jump.groups(0)[0]) + 1

        jump = re.match(r'IP \+= (\d+)', text)
        if jump:
            label = i + int(jump.groups(0)[0]) + 1

        jump = re.match(r'IP \+= ([a-z])', text) or re.match(
            r'IP = ([a-z]) \+ IP', text
        )
        if jump:
            step = jump.groups(0)[0]
            prev = lines[i - 1]
            m = re.search(r'' + step + r' = (\w+ (>|==) \w+)', prev)
            if m:
                label = i + 2
                condition = f', if {m.groups(0)[0]}'

        if label:
            labels.add(label)
            label = f'<--- jump L{label}{condition}'
        elif text[:2] == 'IP':
            label = '<--- jump ???'

        ins = f'{op:4} {A:2} {B:2} {C:2}'
        line = f'{ins:24}# {text:15} {label}'
        lines.append(line)

    return lines, labels


def main():
    run(*read_instructions('day21.txt'))


if __name__ == '__main__':
    main()

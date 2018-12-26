#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from collections import Counter, defaultdict
from operator import itemgetter

from utils import copy_to_clipboard


def get_guard_log():
    with open('day04.txt', 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


@copy_to_clipboard
def part1(log):
    guard_id = max(log, key=lambda gid: len(log[gid]))
    minute, _ = Counter(log[guard_id]).most_common()[0]
    return guard_id * minute


@copy_to_clipboard
def part2(log):
    guard_id, minute, _ = max(
        ((gid,) + Counter(minutes).most_common()[0] for gid, minutes in log.items()),
        key=itemgetter(2),
    )
    return guard_id * minute


def parse(lines):
    log = defaultdict(list)
    for line in sorted(lines):
        minute, gid = [
            int(x) if x else None
            for x in re.search(r'.{15}(\d{2})(?:[^#]+#(\d+)|.)', line).groups()
        ]
        if gid:
            guard = gid
        elif 'falls' in line:
            sleeping = minute
        else:
            log[guard].extend(range(sleeping, minute))
    return log


def main():
    log = parse(
        [
            '[1518-11-01 00:00] Guard #10 begins shift',
            '[1518-11-01 00:05] falls asleep',
            '[1518-11-01 00:25] wakes up',
            '[1518-11-01 00:30] falls asleep',
            '[1518-11-01 00:55] wakes up',
            '[1518-11-01 23:58] Guard #99 begins shift',
            '[1518-11-02 00:40] falls asleep',
            '[1518-11-02 00:50] wakes up',
            '[1518-11-03 00:05] Guard #10 begins shift',
            '[1518-11-03 00:24] falls asleep',
            '[1518-11-03 00:29] wakes up',
            '[1518-11-04 00:02] Guard #99 begins shift',
            '[1518-11-04 00:36] falls asleep',
            '[1518-11-04 00:46] wakes up',
            '[1518-11-05 00:03] Guard #99 begins shift',
            '[1518-11-05 00:45] falls asleep',
            '[1518-11-05 00:55] wakes up',
        ]
    )
    assert part1(log) == 240
    assert part2(log) == 4455

    log = get_guard_log()
    assert part1(log) == 38813
    assert part2(log) == 141071


if __name__ == '__main__':
    main()

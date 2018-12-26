#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from utils import copy_to_clipboard


@copy_to_clipboard
def part1(recipe_count, take=10):
    stop_count = recipe_count + take
    return get_scores(stop_count=stop_count)[recipe_count:stop_count]


@copy_to_clipboard
def part2(digits):
    return get_scores(digits=digits).index(digits)


def get_scores(**kwargs):
    scores = '37'
    elf1, elf2 = 0, 1
    count = len(scores)
    stop_count = kwargs.get('stop_count', 0)
    digits = kwargs.get('digits', '')
    tail = -len(digits) - 1
    while True:
        s1, s2 = int(scores[elf1]), int(scores[elf2])
        recipe = str(s1 + s2)
        scores += recipe
        count += len(recipe)
        elf1 = (elf1 + 1 + s1) % count
        elf2 = (elf2 + 1 + s2) % count
        if stop_count and count >= stop_count:
            break
        if digits and digits in scores[tail:]:
            break
    return scores


def main():
    assert part1(5) == '0124515891'
    assert part1(9) == '5158916779'
    assert part1(18) == '9251071085'
    assert part1(320851) == '7116398711'

    assert part2('01245') == 5
    assert part2('51589') == 9
    assert part2('92510') == 18
    assert part2('59414') == 2018
    assert part2('320851') == 20316365


if __name__ == '__main__':
    main()

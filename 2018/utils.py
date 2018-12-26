#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from functools import wraps
from os import system


def copy_to_clipboard(func):
    @wraps(func)
    def decorator(*args, **kwargs):
        result = func(*args, **kwargs)
        system('echo "{}" | tr -d "\n" | xsel -ib'.format(result))
        print('copied to clipboard:', result)
        return result

    return decorator


class COLORS:
    RED = '\033[91m'
    GREEN = '\033[92m'
    BLUE = '\033[94m'
    END = '\033[0m'


def text_color(text, color):
    return '{}{}{}'.format(color, text, COLORS.END)

def green(text):
    return text_color(text, COLORS.GREEN)

def red(text):
    return text_color(text, COLORS.RED)

def blue(text):
    return text_color(text, COLORS.BLUE)

#!/usr/bin/env gdb
#   encoding: utf8
#   file: colour_filter.py

from typing import Iterator, Text

import gdb

import re
import os


def should_skip(filename, funcname):
    if filename is None or funcname is None: return True
    if isinstance(funcname, int): return True
    if filename.startswith("/usr/"): return True
    if funcname.startswith("std::"): return True
    return False

def cleanup_std(x):
    x_orig = x
    x = re.sub(r"std::unique_ptr<(.*?), std::default_delete<\1 ?> ?>", r"std::unique_ptr<\1>", x)
    x = re.sub(r"std::vector<(.*?), std::allocator<\1 ?> ?>", r"std::vector<\1>", x)

    if x_orig != x:
        return cleanup_std(x)
    else:
        return x

def get_screen_width():
    return gdb.parameter('width')

def length_colored_string(colored_string):
    """This function calculates length of string with terminal control
    sequences.
    """
    start = 0
    term_seq_len = 0
    while True:
        begin = colored_string.find('\033', start)
        if begin == -1:
            break

        end = colored_string.find('m', begin)
        if end == -1:
            end = len(s)

        term_seq_len += end - begin + 1
        start = end

    return len(colored_string) - term_seq_len


# This one is a hack that constructs a full string for the whole Frame, instead
# of following the GDB Python API of a FrameDecorator.
# This one is currently unused, as I managed to create satisfying results
# by following the API.
class FrameColorizer(gdb.FrameDecorator.FrameDecorator):

    def __init__(self, *args, depth=0, **kwargs):
        super(FrameColorizer, self).__init__(*args, **kwargs)

        self._depth = depth
        self.frame = super(FrameColorizer, self).inferior_frame()

        filename = super(FrameColorizer, self).filename()
        func = super(FrameColorizer, self).function()
        self.grayout = should_skip(filename, func)

    def __str__(self):
        is_print_address = gdb.parameter('print address') and False

        part1 = self.depth(grayout)
        part2 = self.function(grayout)
        if grayout:
            part2 += ' \033[2;37m(' + self.frame_args(grayout) + '\033[2;37m)'
        else:
            part2 += ' \033[1;37m(' + self.frame_args(grayout) + '\033[1;37m)'
        part3 = self.filename(grayout) + self.line(grayout)

        if is_print_address:
            part1 += '  ' + self.address(grayout) + ' in '
        else:
            part1 += ' '

        part2 = cleanup_std(part2)

        parts = part1 + part2 + ' at ' + part3

        screen_width = get_screen_width()
        if screen_width is not None and len(parts) > screen_width:
            shift_width = int(length_colored_string(part1)) - 1
            shift_width -= 3 * int(is_print_address)  # compensate ' in ' part
            value = part1 + part2 + '\n'
            value += ' ' * shift_width + ' at ' + part3
        else:
            value = parts

        return value + '\033[0m'


    def address(self):
        address = super(FrameColorizer, self).address()
        return '\033[0;2m0x%016x' % address

    def depth(self):
        if self.grayout:
            return '\033[2;37m#%-3d\033[0m' % self._depth
        else:
            return '\033[1;37m#%-3d\033[0m' % self._depth

    def filename(self):
        filename = super(FrameColorizer, self).filename()
        filename = os.path.realpath(filename)
        if self.grayout:
            return '\033[2;37m%s\033[0m' % filename
        else:
            return '\033[0;36m%s\033[0m' % filename

    def line(self):
        value = super(FrameColorizer, self).line()
        if self.grayout:
            return '\033[2;35m:%d\033[0m' % value if value else ''
        else:
            return '\033[0;35m:%d\033[0m' % value if value else ''

    def function(self):
        func = super(FrameColorizer, self).function()

        # GDB could somehow resolve function name by its address.
        # See details here https://cygwin.com/ml/gdb/2017-12/msg00013.html
        if isinstance(func, int):
            # Here we have something like
            # > raise + 272 in section .text of /usr/lib/libc.so.6
            # XXX: gdb.find_pc_line
            symbol = gdb.execute('info symbol 0x%016x' % func, False, True)

            # But here we truncate layout in binary
            # > raise + 272
            name = symbol[:symbol.find('in section')].strip()

            # Check if we in format
            # > smthing + offset
            parts = name.rsplit(' ', 1)
            # > raise
            if len(parts) == 1:
                return name

            try:
                offset = hex(int(parts[1]))
            except ValueError:
                return name

            if self.grayout:
                return '\033[2;34m' + parts[0] + ' ' + offset + '\033[0m'
            else:
                return '\033[1;34m' + parts[0] + ' ' + offset + '\033[0m'
        else:
            func = cleanup_std(func)

            NS_PATTERN = r"^([A-Za-z0-9_:]*)::"
            ARG_PATTERN = r"\((.*)\)$"
            if self.grayout:
                return '\033[0;2;34m' + func + '\033[0m'
            else:
                func = re.sub(NS_PATTERN, "\033[22m\\1::\033[1m", func, 1)
                func = re.sub(ARG_PATTERN, "(\033[22m\\1\033[1m)", func, 1)
                return '\033[0;1;34m' + func + '\033[0m'

    def frame_args(self):
        try:
            block = self.frame.block()
        except RuntimeError:
            block = None

        while block is not None:
            if block.function is not None:
                break
            block = block.superblock

        if block is None:
            return ''

        args = []

        def format_val(val, type):
            x = str(val);
            if type.is_scalar:
                return "\033[31m" + x + "\033[0m"
            return x

        for sym in block:
            if not sym.is_argument:
                continue;
            val = sym.value(self.frame)
            if self.grayout:
                arg = '\033[2;3;33m%s\033[0m ' % sym.type
                arg += '\033[2;33m%s\033[0;2m=%s' % (sym, format_val(val, sym.type)) if str(val) else str(sym)
            else:
                arg = '\033[3;33m%s\033[0m ' % sym.type
                arg += '\033[1;33m%s\033[0m=%s' % (sym, format_val(val, sym.type)) if str(val) else str(sym)
            args.append(arg)

        return '\033[0m' + (', '.join(args))












class FrameColorizer(gdb.FrameDecorator.FrameDecorator):

    def __init__(self, *args, depth=0, **kwargs):
        super(FrameColorizer, self).__init__(*args, **kwargs)

        self._depth = depth
        self.frame = super(FrameColorizer, self).inferior_frame()

        filename = super(FrameColorizer, self).filename()
        func = super(FrameColorizer, self).function()
        self.grayout = should_skip(filename, func)

    def filename(self):
        filename = super(FrameColorizer, self).filename()
        if filename is None: return None

        filename = os.path.realpath(filename)
        if self.grayout:
            return '\033[2;36m%s\033[0m' % filename
        else:
            return filename

    def function(self):
        func = super(FrameColorizer, self).function()
        if isinstance(func, int):
            return func
        else:
            func = cleanup_std(func)

            NS_PATTERN = r"^([A-Za-z0-9_:]*)::"
            ARG_PATTERN = r"\((.*)\)$"
            if self.grayout:
                return '\033[2m' + func + '\033[0m'
            else:
                func = re.sub(NS_PATTERN, "\033[22m\\1::\033[1m", func, 1)
                func = re.sub(ARG_PATTERN, "(\033[22m\\1\033[1m)", func, 1)
                return '\033[1m' + func + '\033[0m'

    def frame_args(self):

        class SymVal():
            def __init__(self, symbol, value):
                self.sym = symbol
                self.val = value

            def value(self):
                return self.val

            def symbol(self):
                return "\033[36m" + cleanup_std(str(self.sym)) + "\033[0m"


        try:
            block = self.frame.block()
        except RuntimeError:
            block = None

        while block is not None:
            if block.function is not None:
                break
            block = block.superblock

        if block is None:
            return None

        args = []

        for sym in block:
            if not sym.is_argument:
                continue;
            val = sym.value(self.frame)
            args.append(SymVal(sym, val))

        return args











class ColoringFilter:
    def __init__(self, priority, enabled=True):
        """
        :param priority: The priority of the filter relative to other filters.
        :param enabled: A boolean that indicates whether this filter is enabled
        and should be executed.
        """
        self.name = "color"
        self.priority = priority
        self.enabled = enabled

    def filter(self, iters: Iterator[gdb.Frame]) -> Iterator[gdb.Frame]:
        depth = 0
        for frame in iters:
            yield FrameColorizer(frame, depth=depth)
            depth += 1


class SkipStdFilter:
    def __init__(self, priority, enabled=True):
        """
        :param priority: The priority of the filter relative to other filters.
        :param enabled: A boolean that indicates whether this filter is enabled
        and should be executed.
        """
        self.name = "skip-std"
        self.priority = priority
        self.enabled = enabled

    def filter(self, iters: Iterator[gdb.Frame]) -> Iterator[gdb.Frame]:
        for frame in iters:
            if not should_skip(frame.filename(), frame.function()):
                yield frame


# Register this frame filter with the global frame_filters dictionary.
simplifier = SkipStdFilter(priority=10)
gdb.frame_filters[simplifier.name] = simplifier

colorizer = ColoringFilter(priority=0)
gdb.frame_filters[colorizer.name] = colorizer


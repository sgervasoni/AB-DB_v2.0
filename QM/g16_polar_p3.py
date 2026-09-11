#!/usr/bin/env python3

# Written by Anders S. Christensen (2015) University of Wisconsin-Madison
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to

from sys import argv, exit
from math import sqrt


def tensor_from_line(line):
    # Format in logfile:
    # " Exact polarizability: xx xy yy xz yz zz"
    tensor = [
        [0.0, 0.0, 0.0],
        [0.0, 0.0, 0.0],
        [0.0, 0.0, 0.0],
    ]

    tokens = line.split()

    tensor[0][0] = float(tokens[2])
    tensor[1][0] = float(tokens[3])
    tensor[2][0] = float(tokens[5])

    tensor[0][1] = float(tokens[3])
    tensor[1][1] = float(tokens[4])
    tensor[2][1] = float(tokens[6])

    tensor[0][2] = float(tokens[5])
    tensor[1][2] = float(tokens[6])
    tensor[2][2] = float(tokens[7])

    return tensor


def read_tensor(filename):
    with open(filename, "r") as f:
        lines = f.readlines()

    tensor = None

    for line in lines:
        if "Exact polarizability:" in line:
            tensor = tensor_from_line(line)

    if tensor is None:
        print(f"{filename} ERROR: Did not parse tensor correctly.")
        exit()

    return tensor


def calc_anisotropic_polarizablility(tensor):
    # See Stephan Sauer (2011) "Molecular Electromagnetism"
    # page 82.
    a = 0.0

    for i in range(3):
        for j in range(3):
            a += 3.0 * tensor[i][j] * tensor[i][j] - tensor[i][i] * tensor[j][j]

    return sqrt(a * 0.5)


def calc_isotropic_polarizablility(tensor):
    # See Stephan Sauer (2011) "Molecular Electromagnetism"
    # page 82.
    a = 0.0

    for i in range(3):
        a += tensor[i][i]

    return a / 3.0


if __name__ == "__main__":
    filename = argv[1]
    tensor = read_tensor(filename)
    a = calc_anisotropic_polarizablility(tensor)
    i = calc_isotropic_polarizablility(tensor)

    print("{:<30s} {:8.2f} {:8.2f}".format(filename, i, a))


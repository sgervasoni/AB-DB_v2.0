#!/usr/bin/env python3
# This script adapts the Gaussian parser for xtb freq.out files (from --ohess). It searches for the line with the 3×3 polarizability tensor (typically formatted as xx xy xz yy yz zz), parses it, computes isotropic and anisotropic values using the same formulas, and prints them matching the original format.
# Usage: python xtb_polar.py freq.out

from sys import argv, exit
from math import sqrt

def tensor_from_line(line):
    """Parse 3x3 polarizability tensor from xtb line."""
    tokens = line.split()
    if len(tokens) < 9:
        return None
    try:
        tensor = [
            [float(tokens[0]), float(tokens[1]), float(tokens[2])],
            [float(tokens[3]), float(tokens[4]), float(tokens[5])],
            [float(tokens[6]), float(tokens[7]), float(tokens[8])]
        ]
        return tensor
    except ValueError:
        return None

def read_tensor(filename):
    """Read polarizability tensor from xtb freq.out file."""
    with open(filename, 'r') as f:
        lines = f.readlines()
    tensor = None
    for line in lines:
        if 'xx' in line and 'xy' in line and 'yy' in line:  # Typical xtb format: xx     xy     xz     yy     yz     zz
            tensor = tensor_from_line(line)
            if tensor is not None:
                break
    if tensor is None:
        print(f"{filename}: ERROR: Did not parse polarizability tensor correctly.")
        exit(1)
    return tensor

def calc_isotropic_polarizability(tensor):
    """Calculate isotropic polarizability: (1/3) * trace(alpha)."""
    trace = tensor[0][0] + tensor[1][1] + tensor[2][2]
    return trace / 3.0

def calc_anisotropic_polarizability(tensor):
    """Calculate anisotropic polarizability: sqrt( (1/2) * sum_{i,j} (alpha_ij - alpha_ii * delta_ij)^2 )."""
    a = 0.0
    for i in range(3):
        for j in range(3):
            diff = tensor[i][j] - tensor[i][i] if i == j else tensor[i][j]
            a += diff * diff
    return sqrt(a / 2.0)

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage: python xtb_polar.py freq.out")
        exit(1)
    filename = argv[1]
    tensor = read_tensor(filename)
    iso = calc_isotropic_polarizability(tensor)
    aniso = calc_anisotropic_polarizability(tensor)
    print(f"{filename:30s} {iso:8.2f} {aniso:8.2f}")


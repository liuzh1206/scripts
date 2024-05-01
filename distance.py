#!/bin/env python
import sys
import ase.io


poscar = "POSCAR"
N = 14
d = 3

if sys.argv:
    poscar = sys.argv[1]
    N = int(sys.argv[2])
    d = float(sys.argv[3])

atoms = ase.io.read(poscar, format='vasp')

g_max = max(atoms.positions[:N, 2])
g_min = min(atoms.positions[:N, 2])
Sc2CTT_max = max(atoms.positions[N:, 2])
Sc2CTT_min = min(atoms.positions[N:, 2])


d_ori = 0
g_high = None

if g_max < Sc2CTT_min:
    g_high = False
    d_ori = Sc2CTT_min - g_max
else:
    g_high = True
    d_ori = g_min - Sc2CTT_max
    pass

for i in range(N):
    if g_high:
        atoms.positions[i] += [0, 0, d-d_ori]
        pass
    else:
        atoms.positions[i] -= [0, 0, d-d_ori]
        pass
    pass

ase.io.write(f'POSCAR', atoms)

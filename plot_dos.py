#!/bin/env python
# import re
import os
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import colors
import pandas as pd


class DosPloter(object):
    def __init__(self, path='./', atoms={}, is_spin=False, style='fast'):

        self.dos = []
        self.pdoss = {}
        self.path = path
        self.atoms = atoms
        self.is_spin = is_spin
        self.plt = plt
        self.plt.style.use(style)
        self.fig = self.plt.figure()
        self.ax = self.fig.add_subplot(111)

        self.ax.set_ylabel('Energy(eV)')

        self.ax.axvline(x=0, color='black', lw=1, ls='-')
        self.ax.axhline(y=0, color='gray', lw=1, ls='--')
        self.plot_dos()

        return

    def plot_dos(self):
        doss = np.loadtxt(os.path.join(self.path, 'TDOS.dat')).T
        if self.is_spin:
            self.dos.append(self.ax.plot(doss[1], doss[0], label='dos_up')[0])
            self.dos.append(self.ax.plot(doss[2], doss[0], label='dos_dw')[0])
            pass
        else:
            self.dos.append(self.ax.plot(doss[1], doss[0], label='dos')[0])
            pass
        return

    def plot(self):
        for atom in self.atoms:
            self.pdoss[atom] = {}
            pdos_file = os.path.join(self.path, 'PDOS_'+atom+'.dat')
            with open(pdos_file, 'r') as f:
                name = f.readline().split()
                pass
            if not self.is_spin:
                pdoss = pd.read_csv(pdos_file, sep='\\s+', comment='#', names=name)
                for orbit in self.atoms[atom]:
                    self.pdoss[atom][orbit] = self.ax.plot(
                        pdoss[orbit], pdoss['#Energy'],
                        label=atom+orbit
                    )[0]
                    pass
                pass
            elif atom.split('_')[-1] == 'UP':
                pdoss = pd.read_csv(pdos_file, sep='\\s+', comment='#', names=name)
                for orbit in self.atoms[atom]:
                    self.pdoss[atom][orbit] = self.ax.plot(
                        pdoss[orbit], pdoss['#Energy'],
                        label=atom+orbit
                    )[0]
                    pass
                pass
            elif atom.split('_')[-1] == 'DW':
                pdoss = pd.read_csv(pdos_file, sep='\\s+', comment='#', names=name)
                for orbit in self.atoms[atom]:
                    self.pdoss[atom][orbit] = self.ax.plot(
                        pdoss[orbit], pdoss['#Energy'],
                        label=atom+orbit
                    )[0]
                    pass
                pass

            pass
        return

    def set_dos_color(self, color):
        if self.is_spin:
            self.dos[0].set_color(color[0])
            self.dos[1].set_color(color[1])
            pass
        else:
            self.dos[0].set_color(color)
            pass

        return

    def get_plt(self):
        return self.plt

    def get_figure(self):
        return self.fig

    def get_axes(self):
        return self.ax

    pass


# s py pz px dxy dyz dz2 dxz dx2 fy3x2 fxyz fyz2 fz3 fxz2 fzx2 fx3 tot
if __name__ == '__main__':
    dp = DosPloter(
        path='./',
        atoms={
        },
        is_spin=True,
        style='bandos',
    )

    dp.ax.set_ylim(-0.4, 0.4)
    dp.ax.set_xlim(-3, 3)
    dp.plot()
    dp.set_dos_color(['green', 'blue'])

    dp.plt.savefig('dos.tiff')
    dp.plt.show()
    pass

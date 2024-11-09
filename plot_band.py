#!/bin/env python
# import re
import os
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import colors
import pandas as pd


class BandPloter(object):
    def __init__(self, path='./', atoms={}, is_spin=False, style='fast', scale=1.):

        self.bands_up = []
        self.bands_dw = []
        self.bands = []
        self.pbands = {}
        self.path = path
        self.scale = scale
        self.atoms = atoms
        self.is_spin = is_spin
        self.plt = plt
        self.plt.style.use(style)
        self.fig = self.plt.figure()
        self.ax = self.fig.add_subplot(111)

        self.ax.set_ylabel('Energy(eV)')

        self.klabel = pd.read_csv(
            os.path.join(path, 'KLABELS'),
            sep='\\s+',
            skiprows=1, skipfooter=3,
            names=['label', 'tick'],
            engine='python'
        )

        for index, label in enumerate(self.klabel['label']):
            if label == 'GAMMA':
                self.klabel.loc[index, 'label'] = '$\\mathrm{\\Gamma}$'
                pass
            pass

        self.ax.set_xticks(self.klabel['tick'])
        self.ax.set_xticklabels(self.klabel['label'])
        self.ax.grid(axis='x', color='gray', lw=2, ls='--')
        self.ax.axhline(y=0, color='gray', lw=2, ls='--')
        self.ax.set_xlim(
            self.klabel.loc[0, 'tick'], self.klabel.iloc[-1, 1])

        self.plot_band()

        return

    def plot_band(self):
        if self.is_spin:
            bands = np.loadtxt(os.path.join(
                self.path, 'REFORMATTED_BAND_DW.dat')).T
            for index, band in enumerate(bands[1:]):
                self.bands_dw.append(
                    self.ax.plot(
                        bands[0], band,
                        color='green',
                        zorder=0,
                        label=f'band_up{index}'
                    )[0]
                )
                pass
            bands = np.loadtxt(os.path.join(
                self.path, 'REFORMATTED_BAND_UP.dat')).T
            for index, band in enumerate(bands[1:]):
                self.bands_up.append(
                    self.ax.plot(
                        bands[0], band,
                        color='blue',
                        zorder=0,
                        label=f'band_dw{index}'
                    )[0]
                )
                pass
            pass
        else:
            bands = np.loadtxt(os.path.join(
                self.path, 'REFORMATTED_BAND.dat')).T
            for index, band in enumerate(bands[1:]):
                self.bands.append(
                    self.ax.plot(
                        bands[0], band,
                        color='black',
                        zorder=0,
                        label=f'band{index}'
                    )[0]
                )
                pass
        return

    def plot(self):
        for atom in self.atoms:
            self.pbands[atom] = {}
            band_file = os.path.join(self.path, 'PBAND_'+atom+'.dat')
            with open(band_file, 'r') as f:
                name = f.readline().split()
                pass
            bands = pd.read_csv(band_file, sep='\\s+', comment='#', names=name)
            for orbit in self.atoms[atom]:
                self.pbands[atom][orbit] = self.ax.scatter(
                    x=bands['#K-Path'], y=bands['Energy'],
                    s=bands[orbit]*self.scale,
                    label=f'{atom} {orbit}'
                )
                pass
            pass
        return

    def set_band_color(self, color):
        if self.is_spin:
            for band in self.bands_up:
                band.set_color(color[0])
            pass
            for band in self.bands_dw:
                band.set_color(color[1])
            pass
        else:
            for band in self.bands:
                band.set_color(color)
                pass
            pass
        return

    def get_plt(self):
        return self.plt

    def get_figure(self):
        return self.fig

    def get_axes(self):
        return self.ax

    pass


# s py pz px dxy dyz dz2 dxz x2-y2 fy3x2 fxyz fyz2 fz3 fxz2 fzx2 fx3 tot
if __name__ == '__main__':
    bp = BandPloter(
        path='./',
        atoms={
        },
        is_spin=True,
        style='bandos',
        scale=30
    )

    bp.ax.set_ylim(-0.4, 0.4)
    bp.plot()
    bp.set_band_color(['green', 'blue'])

    bp.plt.savefig('band.tiff')
    bp.plt.show()
    pass

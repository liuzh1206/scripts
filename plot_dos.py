#!/bin/env python
import re
import os
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

plt.style.use('bmh')
mpl.rcParams['text.usetex'] = True
# mpl.rcParams['font.family'] = 'sans-serif'  # 设置默认字体为无衬线字体
# mpl.rcParams['font.sans-serif'] = ['Arial']  # 设置无衬线字体为 Arial
# mpl.rcParams['mathtext.fontset'] = 'custom'  # 自定义数学符号的字体集
# mpl.rcParams['mathtext.rm'] = 'Arial'  # 设置数学符号的字体为 Arial


class BandPlotter:
    def __init__(self,
                 path='./',
                 atoms=None,
                 sum_name='',
                 is_Spin=False,
                 is_f=False,
                 N=93
                 ):
        self.N = N
        self.is_Spin = is_Spin
        self.path = path
        self.atoms = atoms
        self.sum_name = sum_name
        self.colors = [(128, 0, 0), (139, 0, 0), (165, 42, 42), (178, 34, 34), (220, 20, 60), (255, 0, 0), (255, 99, 71), (255, 127, 80), (205, 92, 92), (240, 128, 128), (233, 150, 122), (250, 128, 114), (255, 160, 122), (255, 69, 0), (255, 140, 0), (255, 165, 0), (255, 215, 0), (184, 134, 11), (218, 165, 32), (238, 232, 170), (189, 183, 107), (240, 230, 140), (128, 128, 0), (255, 255, 0), (154, 205, 50), (85, 107, 47), (107, 142, 35), (124, 252, 0), (127, 255, 0), (173, 255, 47), (0, 100, 0), (0, 128, 0), (34, 139, 34), (0, 255, 0), (50, 205, 50), (144, 238, 144), (152, 251, 152), (143, 188, 143), (0, 250, 154), (0, 255, 127), (46, 139, 87), (102, 205, 170), (60, 179, 113), (32, 178, 170), (47, 79, 79), (0, 128, 128), (0, 139, 139), (0, 255, 255), (0, 255, 255), (224, 255, 255), (0, 206, 209), (64, 224, 208), (72, 209, 204), (175, 238, 238), (127, 255, 212), (176, 224, 230), (95, 158, 160), (70, 130, 180), (100, 149, 237), (0, 191, 255), (30, 144, 255), (173, 216, 230), (135, 206, 235), (135, 206, 250), (25, 25, 112), (0, 0, 128), (0, 0, 139),
                       (0, 0, 205), (0, 0, 255), (65, 105, 225), (138, 43, 226), (75, 0, 130), (72, 61, 139), (106, 90, 205), (123, 104, 238), (147, 112, 219), (139, 0, 139), (148, 0, 211), (153, 50, 204), (186, 85, 211), (128, 0, 128), (216, 191, 216), (221, 160, 221), (238, 130, 238), (255, 0, 255), (218, 112, 214), (199, 21, 133), (219, 112, 147), (255, 20, 147), (255, 105, 180), (255, 182, 193), (255, 192, 203), (250, 235, 215), (245, 245, 220), (255, 228, 196), (255, 235, 205), (245, 222, 179), (255, 248, 220), (255, 250, 205), (250, 250, 210), (255, 255, 224), (139, 69, 19), (160, 82, 45), (210, 105, 30), (205, 133, 63), (244, 164, 96), (222, 184, 135), (210, 180, 140), (188, 143, 143), (255, 228, 181), (255, 222, 173), (255, 218, 185), (255, 228, 225), (255, 240, 245), (250, 240, 230), (253, 245, 230), (255, 239, 213), (255, 245, 238), (245, 255, 250), (112, 128, 144), (119, 136, 153), (176, 196, 222), (230, 230, 250), (255, 250, 240), (240, 248, 255), (248, 248, 255), (240, 255, 240), (255, 255, 240), (240, 255, 255), (255, 250, 250)]

        self.colors = np.array(
            [(i[0] / 255, i[1] / 255, i[2] / 255) for i in self.colors])
        self.colors = np.split(self.colors, 10)

    def load_doss(self, path):
        doss = np.loadtxt(path)
        return doss.T

    def load_pdoss(self, path):
        file_name = os.path.basename(path)
        atom_name = file_name.split('.')[0]

        if self.is_Spin:
            if atom_name.split('_')[1] == 'SUM':
                atom_name = atom_name.split(
                    '_')[1] + '_' + atom_name.split('_')[2] + '_' + atom_name.split('_')[3]
            else:
                atom_name = atom_name.split(
                    '_')[1] + '_' + atom_name.split('_')[2]
                pass
        else:
            if atom_name.split('_')[1] == 'SUM':
                atom_name = atom_name.split(
                    '_')[1] + '_' + atom_name.split('_')[2]
            else:
                atom_name = atom_name.split('_')[1]
                pass

        with open(path, 'r') as f:
            orbit_name = f.readline().split()[1:]
            pdos = np.loadtxt(f)

        self.orbit_name_map = dict(
            zip(orbit_name, range(1, len(orbit_name) + 1)))

        return pdos.T, atom_name, orbit_name

    def load_fermi(self, path):
        with open(path, 'r') as f:
            f.readline()
            E_fermi = f.readline().split()[0]
        return float(E_fermi)

    def plot(self):
        # plot fermi energy level
        E_fermi = self.load_fermi(os.path.join(self.path, 'FERMI_ENERGY'))
        # E_fermi = 0
        fig = plt.figure(figsize=(11, 7))
        # fig.patch.set_facecolor('#FFFFFF')
        fig.patch.set_alpha(0)
        ax = fig.add_subplot(1, 1, 1)
        ax.axvline(x=0, color='black', lw=1, ls='--')

        # plot bands
        if self.is_Spin:
            tdos = self.load_doss(os.path.join(self.path,
                                               './TDOS.dat'))
            ax.plot(tdos[1], tdos[0], color='green', alpha=1, lw=0.2)
            ax.plot(tdos[2], tdos[0], color='blue', alpha=1, lw=0.2)
        else:
            tdos = self.load_doss(os.path.join(self.path,
                                               'TDOS.dat'))
            ax.plot(tdos[1], tdos[0], color='black', alpha=1, lw=0.2)

        # get pband datas
        files = os.listdir(self.path)
        pdos_file = []
        for file in files:
            if re.search(r'^PDOS', file):
                pdos_file.append(file)
        file_path = [os.path.join(self.path, i) for i in pdos_file]

        # plot echo atom's contribute
        pband_legend = {
            'orbit_lines': [],
            'orbit_legends': []
        }

        for atom_index, file in enumerate(file_path):
            pdos, atom_name, orbit_name = self.load_pdoss(file)
            if atom_name not in self.atoms:
                continue
            for orbit_index, orbit in enumerate(self.atoms[atom_name]):
                orbit_alpha = -1
                orbit_line = None
                orbit_names = ''
                color = self.colors[atom_index-2][orbit_index*2]
                if atom_name == 'SUM_H_UP':
                    # color = '#EEC0CC'
                    pass
                elif atom_name == 'SUM_H_DW':
                    # color = '#EEE0FC'
                    pass
                elif atom_name == 'SUM_T_UP':
                    # color = '#FFF80E'
                    pass
                elif atom_name == 'SUM_T_DW':
                    # color = '#08080E'
                    pass
                pdos_line, = ax.plot(
                        pdos[self.orbit_name_map[orbit]],
                        pdos[0],
                        color=color,
                        label=atom_name + ' ' + orbit
                        )
                orbit_line = pdos_line
                orbit_names = atom_name + ' ' + orbit
                pband_legend['orbit_lines'].append(orbit_line)
                pband_legend['orbit_legends'].append(orbit_names)
                pass

        ax.legend(handles=pband_legend['orbit_lines'], loc='best')

        # ax.set_ylabel(r'Energy(eV)', fontsize=25, verticalalignment='center')
        ax.set_ylabel(r'$\mathbf{Energy(eV)}$',
                      fontsize=25, verticalalignment='bottom')

        bwith = 0.7
        ax.spines['bottom'].set_linewidth(bwith)  # 图框下边
        ax.spines['left'].set_linewidth(bwith)  # 图框左边
        ax.spines['top'].set_linewidth(bwith)  # 图框上边
        ax.spines['right'].set_linewidth(bwith)  # 图框右边
        ax.spines['bottom'].set_color('#000000')  # 图框下边
        ax.spines['left'].set_color('#000000')  # 图框下边
        ax.spines['top'].set_color('#000000')  # 图框下边
        ax.spines['right'].set_color('#000000')  # 图框下边
        ax.tick_params(labelsize=30)
        # ax.patch.set_facecolor('#FFFFFF')
        ax.patch.set_alpha(0)
        # ax.set_aspect(0.26)
        ax.grid(None)

        ax.tick_params(axis='x', pad=15)

        return plt


'''
orbit_name_map = {
's': 1,
'py': 2,
'pz': 3,
'px': 4,
'dxy': 5,
'dyz': 6,
'dz2': 7,
'dxz': 8,
'x2-y2': 9,
'tot': 10
            'SUM_T_DW': ['tot'],
            'SUM_T_UP': ['tot'],
            'SUM_H_DW': ['tot'],
            'SUM_H_UP': ['tot'],
}
'''

if __name__ == '__main__':
    bp = BandPlotter(
        path='./',
        atoms={
            'SUM_T_DW': ['dxy', 'dyz', 'dz2', 'dxz', 'dx2'],
        },
        is_Spin=True)
    plt1 = bp.plot()
    plt1.xlim(-13, 23)
    plt1.ylim(-1, 0.4)
    plt1.savefig('dos.png')
    plt1.show()

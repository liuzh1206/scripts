#!/bin/env python
import numpy as np
from rich.progress import track, Progress


def partial_spin_split(input_file='', spin='up', out_file=''):
    ps = Progress()
    task = ps.add_task(f'reading {input_file}', start=True, total=10)
    ps.start()
    with open(input_file, 'r') as fp:
        fp.readline()
        scale = float(fp.readline())
        R = []
        R.append(np.loadtxt([fp.readline()]))
        R.append(np.loadtxt([fp.readline()]))
        R.append(np.loadtxt([fp.readline()]))
        R = np.array(R) * scale
        atoms = fp.readline().split()
        num_atoms = np.loadtxt([fp.readline()], dtype=np.int64)
        pos_type = fp.readline().split()[0]
        atoms_pos = np.loadtxt(fp, max_rows=sum(num_atoms))
        fp.readline()

        Nx, Ny, Nz = np.loadtxt([fp.readline()], dtype=np.int64)
        ps.update(task, advance=2)

        chg1 = np.loadtxt(fp, max_rows=int(Nx*Ny*Nz/10))
        if Nx*Ny*Nz % 10 > 0:
            line = fp.readline()
            chg = np.append(chg1, np.loadtxt([line]))
            pass
        ps.update(task, advance=4)

        fp.readline()
        fp.readline()

        chg2 = np.loadtxt(fp, max_rows=int(Nx*Ny*Nz/10))
        if Nx*Ny*Nz % 10 > 0:
            line = fp.readline()
            chg = np.append(chg2, np.loadtxt([line]))
            pass
        ps.update(task, advance=4)
        pass

    ps.stop()

    chg1 = chg1.reshape(Nx*Ny*Nz)
    chg2 = chg2.reshape(Nx*Ny*Nz)
    chg_data = np.array([])

    if spin == 'up':
        chg_data = (chg1 + chg2)/2
    elif spin == 'dw':
        chg_data = (chg1 - chg2)/2

    out = open(out_file, 'w+')

    print(out_file, file=out)
    print(scale, file=out)
    print('   %20.16f %20.16f %20.16f' % tuple(R[0]), file=out)
    print('   %20.16f %20.16f %20.16f' % tuple(R[1]), file=out)
    print('   %20.16f %20.16f %20.16f' % tuple(R[2]), file=out)
    print('   ', *atoms, file=out)
    print('   ', *num_atoms, file=out)
    print(pos_type, file=out)
    for atom_pos in atoms_pos:
        print('%20.16f %20.16f %20.16f' % tuple(atom_pos), file=out)
        pass

    print(file=out)

    print(Nx, Ny, Nz, file=out)

    for line, chg in track(enumerate(chg_data),
                           description=f'writing {out_file}',
                           total=len(chg_data)
                           ):
        out.write(f'  {chg:.10e}')
        if (line+1) % 10 == 0:
            out.write('\n')

    out.close()

    return


if __name__ == '__main__':
    partial_spin_split(input_file='PARCHG', spin='dw',
                       out_file='partial_dw.vasp')
    partial_spin_split(input_file='PARCHG', spin='up',
                       out_file='partial_up.vasp')

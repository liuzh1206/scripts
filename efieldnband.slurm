#!/bin/bash
#SBATCH -J   C-ClH                                         #指定作业名称
#SBATCH --ntasks=128                                  #此次作业所需总核数
#SBATCH --nodes=2                                   #作业所需节点数
#SBATCH --ntasks-per-node=64                     #每个节点分配核数   
#SBATCH -p low                                               #在low分区进行计算 
#SBATCH --output=slurm-efield.log                                  #设置计算输出日志文件    

cd  $SLURM_SUBMIT_DIR

export OMP_NUM_THREADS=1

srun hostname -s | sort -n > nodelist

ulimit -s unlimited
ulimit -l unlimited
ulimit -d unlimited

source /path/to/your/vasp/config/env.sh
export PATH=/path/to/your/vaspkit/bin:${PATH}

NCORE=8

incar="Global Parameters
ISTART =  0            (Read existing wavefunction, if there)
ISPIN  =  1            (Non-Spin polarised DFT)
# ICHARG =  11         (Non-self-consistent: GGA/LDA band structures)
LREAL  = Auto       (Projection operators: automatic)
ENCUT  =  500        (Cut-off energy for plane wave basis set, in eV)
PREC   =  Accurate   (Precision level: Normal or Accurate, set Accurate when perform structure lattice relaxation calculation)
LWAVE  = .TRUE.        (Write WAVECAR or not)
LCHARG = .TRUE.        (Write CHGCAR or not)
ADDGRID= .TRUE.        (Increase grid, helps GGA convergence)
# LVTOT  = .TRUE.      (Write total electrostatic potential into LOCPOT or not)
LVHAR    = .TRUE.      (Write ionic + Hartree electrostatic potential into LOCPOT or not)
LAECHG =  .TRUE.
# NELECT =             (No. of electrons: charged cells, be careful)
# LPLANE = .TRUE.      (Real space distribution, supercells)
# NWRITE = 2           (Medium-level output)
# KPAR   = 2           (Divides k-grid into separate groups)
# NGXF    = 300        (FFT grid mesh density for nice charge/potential plots)
# NGYF    = 300        (FFT grid mesh density for nice charge/potential plots)
# NGZF    = 300        (FFT grid mesh density for nice charge/potential plots)
 
Electronic Relaxation
ISMEAR =  0            (Gaussian smearing, metals:1)
SIGMA  =  0.05         (Smearing value in eV, metals:0.2)
NELM   =  190           (Max electronic SCF steps)
NELMIN =  6            (Min electronic SCF steps)
EDIFF  =  1E-08        (SCF energy convergence, in eV)
# GGA  =  PS           (PBEsol exchange-correlation)
# LORBIT =  11           (PAW radii for projected DOS)
# NEDOS  =  2001          (DOSCAR points)
NBANDS =  300          (Set this parameters manually, 2 * number of bands of collinear-run)
 
Ionic Relaxation
NSW    =  0          (Max ionic steps)
IBRION =  2            (Algorithm: 0-MD, 1-Quasi-New, 2-CG)
ISIF   =  3            (Stress/relaxation: 2-Ions, 3-Shape/Ions/V, 4-Shape/Ions)
EDIFFG = -2E-02        (Ionic convergence, eV/AA)
# ALGO   =  Fast
 
# Spin-Orbit Coupling Calculation
# LSORBIT       = .TRUE.    (Activate SOC)
# LNONCOLLINEAR = .TRUE.
# GGA_COMPAT    = .TRUE.   (Apply spherical cutoff on gradient field)
# VOSKOWN       =  1        (Enhances the magnetic moments and the magnetic energies)
# LMAXMIX       =  4        (For d elements increase LMAXMIX to 4, f: LMAXMIX = 6)
# ISYM          =  -1       (Switch symmetry off)
# SAXIS         =  0 0 1    (Direction of the magnetic field)
# NBANDS        =  768      (Set this parameters manually, 2 * number of bands of collinear-run)
 
DFT-D3 Correction
IVDW    =  13           (DFT-D4 method of method with no damping)

NCORE   =  $NCORE
 
Corrections to the potential and forces in VASP
LDIPOL  =  .TRUE.       (Activate correction of the potential and forces)
IDIPOL  =  3            (Direction of potential and forces)
DIPOL = 0.5 0.5 0.5"


incar_band="Global Parameters
ISTART =  1            (Read existing wavefunction, if there)
ISPIN  =  1            (Non-Spin polarised DFT)
ICHARG =  11         (Non-self-consistent: GGA/LDA band structures)
LREAL  = Auto       (Projection operators: automatic)
ENCUT  =  500        (Cut-off energy for plane wave basis set, in eV)
PREC   =  Accurate   (Precision level: Normal or Accurate, set Accurate when perform structure lattice relaxation calculation)
LWAVE  = .TRUE.        (Write WAVECAR or not)
LCHARG = .TRUE.        (Write CHGCAR or not)
ADDGRID= .TRUE.        (Increase grid, helps GGA convergence)
# LVTOT  = .TRUE.      (Write total electrostatic potential into LOCPOT or not)
# LVHAR    = .TRUE.      (Write ionic + Hartree electrostatic potential into LOCPOT or not)
# LAECHG =  .TRUE.
# NELECT =             (No. of electrons: charged cells, be careful)
# LPLANE = .TRUE.      (Real space distribution, supercells)
# NWRITE = 2           (Medium-level output)
# KPAR   = 2           (Divides k-grid into separate groups)
# NGXF    = 300        (FFT grid mesh density for nice charge/potential plots)
# NGYF    = 300        (FFT grid mesh density for nice charge/potential plots)
# NGZF    = 300        (FFT grid mesh density for nice charge/potential plots)
 
Electronic Relaxation
ISMEAR =  0            (Gaussian smearing, metals:1)
SIGMA  =  0.05         (Smearing value in eV, metals:0.2)
NELM   =  190           (Max electronic SCF steps)
NELMIN =  6            (Min electronic SCF steps)
EDIFF  =  1E-08        (SCF energy convergence, in eV)
# GGA  =  PS           (PBEsol exchange-correlation)
LORBIT =  11           (PAW radii for projected DOS)
# NEDOS  =  2001          (DOSCAR points)
NBANDS =  300          (Set this parameters manually, 2 * number of bands of collinear-run)
 
Ionic Relaxation
NSW    =  0          (Max ionic steps)
IBRION =  2            (Algorithm: 0-MD, 1-Quasi-New, 2-CG)
ISIF   =  3            (Stress/relaxation: 2-Ions, 3-Shape/Ions/V, 4-Shape/Ions)
EDIFFG = -2E-02        (Ionic convergence, eV/AA)
# ALGO   =  Fast
 
# Spin-Orbit Coupling Calculation
# LSORBIT       = .TRUE.    (Activate SOC)
# LNONCOLLINEAR = .TRUE.
# GGA_COMPAT    = .TRUE.   (Apply spherical cutoff on gradient field)
# VOSKOWN       =  1        (Enhances the magnetic moments and the magnetic energies)
# LMAXMIX       =  4        (For d elements increase LMAXMIX to 4, f: LMAXMIX = 6)
# ISYM          =  -1       (Switch symmetry off)
# SAXIS         =  0 0 1    (Direction of the magnetic field)
# NBANDS        =  768      (Set this parameters manually, 2 * number of bands of collinear-run)
 
DFT-D3 Correction
IVDW    =  13           (DFT-D4 method of method with no damping)

NCORE   =  $NCORE
 
Corrections to the potential and forces in VASP
LDIPOL  =  .TRUE.       (Activate correction of the potential and forces)
IDIPOL  =  3            (Direction of potential and forces)
DIPOL = 0.5 0.5 0.5"

cp ../POSCAR .

for E in `seq 0.05 0.05 0.4`;
do


cd n$E/band

echo -e "302" | vaspkit > /dev/null
sed -i "2c50" KPATH.in
cp KPATH.in KPOINTS
echo n$E band 
mpirun    -np  $SLURM_NPROCS   -machinefile  $SLURM_SUBMIT_DIR/nodelist    vasp_std > out
tail OSZICAR
tail OUTCAR

cd ../..

done


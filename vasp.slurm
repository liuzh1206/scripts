#!/bin/bash
#SBATCH -J   efield                                         #指定作业名称
#SBATCH --ntasks=128                                  #此次作业所需总核数
#SBATCH --nodes=2                                   #作业所需节点数
#SBATCH --ntasks-per-node=64                     #每个节点分配核数   
#SBATCH -p low                                               #在low分区进行计算 
#SBATCH --output=slurm-efield.log                                  #设置计算输出日志文件    

source /path/to/your/vasp/config/env.sh

cd  $SLURM_SUBMIT_DIR

ulimit -s unlimited
ulimit -l unlimited
ulimit -d unlimited

export OMP_NUM_THREADS=1

incar_opt="Global Parameters
ISTART =  0            (Read existing wavefunction, if there)
ISPIN  =  1            (Non-Spin polarised DFT)
# ICHARG =  11         (Non-self-consistent: GGA/LDA band structures)
LREAL  = Auto       (Projection operators: automatic)
ENCUT  =  500        (Cut-off energy for plane wave basis set, in eV)
# PREC   =  Accurate   (Precision level: Normal or Accurate, set Accurate when perform structure lattice relaxation calculation)
LWAVE  = .FALSE.        (Write WAVECAR or not)
LCHARG = .FALSE.        (Write CHGCAR or not)
ADDGRID= .TRUE.        (Increase grid, helps GGA convergence)
# LVTOT  = .TRUE.      (Write total electrostatic potential into LOCPOT or not)
# LVHAR  = .TRUE.      (Write ionic + Hartree electrostatic potential into LOCPOT or not)
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
NELM   =  90           (Max electronic SCF steps)
NELMIN =  6            (Min electronic SCF steps)
EDIFF  =  1E-6        (SCF energy convergence, in eV)
# GGA  =  PS           (PBEsol exchange-correlation)

Ionic Relaxation
NSW    =  300          (Max ionic steps)
IBRION =  2            (Algorithm: 0-MD, 1-Quasi-New, 2-CG)
ISIF   =  2            (Stress/relaxation: 2-Ions, 3-Shape/Ions/V, 4-Shape/Ions)
EDIFFG = -2E-02        (Ionic convergence, eV/AA)
# POTIM  = 0.0003
# ISYM =  2            (Symmetry: 0=none, 2=GGA, 3=hybrids)
# ALGO   = VeryFast
Corrections to the potential and forces in VASP
LDIPOL  =  .TRUE.       (Activate correction of the potential and forces)
IDIPOL  =  3            (Direction of potential and forces)
DIPOL = 0.5 0.5 0.5

DFT-D3 Correction
IVDW    =  12           (DFT-D3 method of method with no damping)

IOPTCELL = 1 1 0 1 1 0 0 0 0
"
incar_scf="Global Parameters
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

Corrections to the potential and forces in VASP
LDIPOL  =  .TRUE.       (Activate correction of the potential and forces)
IDIPOL  =  3            (Direction of potential and forces)
DIPOL = 0.5 0.5 0.5

DFT-D3 Correction
IVDW    =  12           (DFT-D3 method of method with no damping)
"
incar_band="Global Parameters
ISTART =  1            (Read existing wavefunction, if there)
ISPIN  =  1            (Non-Spin polarised DFT)
ICHARG =  11         (Non-self-consistent: GGA/LDA band structures)
LREAL  = Auto       (Projection operators: automatic)
ENCUT  =  500        (Cut-off energy for plane wave basis set, in eV)
PREC   =  Accurate   (Precision level: Normal or Accurate, set Accurate when perform structure lattice relaxation calculation)
LWAVE  = .FALSE.        (Write WAVECAR or not)
LCHARG = .FALSE.        (Write CHGCAR or not)
ADDGRID= .TRUE.        (Increase grid, helps GGA convergence)
# LVTOT  = .TRUE.      (Write total electrostatic potential into LOCPOT or not)
# LVHAR  = .TRUE.      (Write ionic + Hartree electrostatic potential into LOCPOT or not)
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
NELMIN =  2            (Min electronic SCF steps)
EDIFF  =  1E-08        (SCF energy convergence, in eV)
# GGA  =  PS           (PBEsol exchange-correlation)
LORBIT =  11           (PAW radii for projected DOS)
# NEDOS  =  2001         (DOSCAR points)

Ionic Relaxation
NSW    =  0            (Max ionic steps)
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
NBANDS        =  210      (Set this parameters manually, 2 * number of bands of collinear-run)

Corrections to the potential and forces in VASP
LDIPOL  =  .TRUE.       (Activate correction of the potential and forces)
IDIPOL  =  3            (Direction of potential and forces)
DIPOL = 0.5 0.5 0.5

DFT-D3 Correction
IVDW    =  12           (DFT-D3 method of method with no damping)

# NCORE = 8
# LREAL= Auto
NPAR=4

# SYMPREC  =  1E-03
"
incar_dos="Global Parameters
ISTART =  1            (Read existing wavefunction, if there) 
ISPIN  =  1            (Non-Spin polarised DFT)
ICHARG =  11          (Non-self-consistent: GGA/LDA band structures)
LREAL  = Auto       (Projection operators: automatic)
ENCUT  =  500        (Cut-off energy for plane wave basis set, in eV)
PREC   =  Accurate   (Precision level: Normal or Accurate, set Accurate when perform structure lattice relaxation calculation)
LWAVE  = .FLASE.        (Write WAVECAR or not)
LCHARG = .FLASE.        (Write CHGCAR or not)
ADDGRID= .TRUE.        (Increase grid, helps GGA convergence)
# LVTOT  = .TRUE.      (Write total electrostatic potential into LOCPOT or not)
# LVHAR  = .TRUE.      (Write ionic + Hartree electrostatic potential into LOCPOT or not)
# NELECT =             (No. of electrons: charged cells, be careful)
# LPLANE = .TRUE.      (Real space distribution, supercells)
# NWRITE = 2           (Medium-level output)
# KPAR   = 2           (Divides k-grid into separate groups)
# NGXF    = 300        (FFT grid mesh density for nice charge/potential plots)
# NGYF    = 300        (FFT grid mesh density for nice charge/potential plots)
# NGZF    = 300        (FFT grid mesh density for nice charge/potential plots)

Electronic Relaxation
ISMEAR =  -5            (Gaussian smearing, metals:1)
SIGMA  =  0.05         (Smearing value in eV, metals:0.2)
NELM   =  190           (Max electronic SCF steps)
NELMIN =  6            (Min electronic SCF steps)
EDIFF  =  1E-08        (SCF energy convergence, in eV)
# GGA  =  PS           (PBEsol exchange-correlation)
LORBIT =  11           (PAW radii for projected DOS)
NEDOS  =  2001         (DOSCAR points)

Ionic Relaxation
NSW    =  0           (Max ionic steps)
IBRION =  2            (Algorithm: 0-MD, 1-Quasi-New, 2-CG)
ISIF   =  3            (Stress/relaxation: 2-Ions, 3-Shape/Ions/V, 4-Shape/Ions)
EDIFFG = -2E-02        (Ionic convergence, eV/AA)
# ALGO   =  Fast

#Spin-Orbit Coupling Calculation
#LSORBIT       = .TRUE.    (Activate SOC)
#LNONCOLLINEAR = .TRUE.
#GGA_COMPAT    = .TRUE.   (Apply spherical cutoff on gradient field)
#VOSKOWN       =  1        (Enhances the magnetic moments and the magnetic energies)
#LMAXMIX       =  4        (For d elements increase LMAXMIX to 4, f: LMAXMIX = 6)
#ISYM          =  -1       (Switch symmetry off)
#SAXIS         =  0 0 1    (Direction of the magnetic field)
#NBANDS        =  768      (Set this parameters manually, 2 * number of bands of collinear-run)

Corrections to the potential and forces in VASP
LDIPOL  =  .TRUE.       (Activate correction of the potential and forces)
IDIPOL  =  3            (Direction of potential and forces)
DIPOL = 0.5 0.5 0.5

DFT-D3 Correction
IVDW    =  12           (DFT-D3 method of method with no damping)
"

srun hostname -s | sort -n >nodelist
echo "$incar_opt" > INCAR
echo "K-Spacing Value to Generate K-Mesh
0
Gamma
   1   1   1
0.0  0.0  0.0">KPOINTS

echo "======================opt1 start========================="
mpirun    -np  $SLURM_NPROCS   -machinefile  $SLURM_SUBMIT_DIR/nodelist    vasp_gam > out
tail OSZICAR
tail OUTCAR
echo "========================opt1 end========================="

cp CONTCAR POSCAR

echo -e "102\n2\n0.04" | vaspkit > /dev/null
echo "=======================opt start========================="
mpirun    -np  $SLURM_NPROCS   -machinefile  $SLURM_SUBMIT_DIR/nodelist    vasp_std > out
tail OSZICAR
tail OUTCAR
echo "=========================opt end========================="

cp CONTCAR scf/POSCAR

[ ! -d scf ] && mkdir scf
cd scf
echo "$incar_scf" > INCAR
echo -e "102\n2\n0.03" | vaspkit > /dev/null
echo "=======================scf start========================="
mpirun    -np  $SLURM_NPROCS   -machinefile  $SLURM_SUBMIT_DIR/nodelist    vasp_std > out
tail OSZICAR
tail OUTCAR
echo "=======================scf start========================="


[ ! -d band ] && mkdir band
cd band
echo "$incar_band" > INCAR
cp ../POSCAR ../POTCAR ../WAVECAR ../CHGCAR .
echo -e "302" | vaspkit > /dev/null
sed -i "2c50" KPATH.in
cp KPATH.in KPOINTS
echo "======================band start========================="
mpirun    -np  $SLURM_NPROCS   -machinefile  $SLURM_SUBMIT_DIR/nodelist    vasp_std > out
tail OSZICAR
tail OUTCAR
echo "=======================band end=========================="
cd ..

[ ! -d dos ] && mkdir dos
cd dos
echo "$incar_dos" > INCAR
cp ../POSCAR ../POTCAR ../WAVECAR ../CHGCAR .
echo -e "102\n2\n0.03" | vaspkit > /dev/null
echo "=======================dos start========================="
mpirun    -np  $SLURM_NPROCS   -machinefile  $SLURM_SUBMIT_DIR/nodelist    vasp_std > out
tail OSZICAR
tail OUTCAR
echo "========================dos end=========================="
cd ..

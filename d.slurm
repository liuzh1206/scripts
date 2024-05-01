#!/bin/bash
#SBATCH -J d_test                                            
#SBATCH -N 1                                 
#SBATCH -n 40                              
#SBATCH -p cpu44c                                                
#SBATCH --output=slurm-d.log                                     

source /home/dell/wsy/app/vasp640/env.sh
export PATH=/home/dell/wsy/app/vaspkit.1.4.0/bin/:$PATH

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

cp ../POSCAR .

for d in `seq 2.5 0.1 4.5`;do
    [ ! -d $d ] && mkdir $d
    cd $d

    python ../distance.py ../POSCAR 14 $d
    echo "$incar_scf" > INCAR
    echo -e "102\n2\n0.03" | vaspkit > /dev/null
    echo "======================$d start========================="
    mpirun    -np  $SLURM_NPROCS   -machinefile  $SLURM_SUBMIT_DIR/nodelist    vasp_std > out
    tail OSZCAR
    tail OUTCAR
    echo "========================$d end========================="

    cd ..
done

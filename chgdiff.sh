$A=g
$B=b
for i in `seq 0.05 0.05 0.40`
do {
    cd $i

    vaspkit -task 426 -dim 3
    echo -e "314\nCHGCAR ../../$A/CHGCAR" `echo ../../$B*`'/CHGCAR' | vaspkit
    mv PLANAR_AVERAGE.dat PLANAR_AVERAGE.dat.old
    vaspkit -task 316 -file CHGDIFF.vasp -dim 3
    mv PLANAR_AVERAGE.dat CHARGE_PLANAR_AVERAGE.dat
    mv PLANAR_AVERAGE.dat.old PLANAR_AVERAGE.dat

    cd ../
    cd n$i

    vaspkit -task 426 -dim 3
    echo -e "314\nCHGCAR ../../$A/CHGCAR" `echo ../../$B*`'/CHGCAR' | vaspkit
    mv PLANAR_AVERAGE.dat PLANAR_AVERAGE.dat.old
    vaspkit -task 316 -file CHGDIFF.vasp -dim 3
    mv PLANAR_AVERAGE.dat CHARGE_PLANAR_AVERAGE.dat
    mv PLANAR_AVERAGE.dat.old PLANAR_AVERAGE.dat

    cd ../
} &
done
wait

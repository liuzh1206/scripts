$A=g
$B=b
for i in `seq 0.05 0.05 0.40`
do {
    cd $i

    echo -e "314\nCHGCAR ../../$A/CHGCAR" `echo ../../$B*`'/CHGCAR' | vaspkit
    vaspkit -task 316 -file CHGDIFF.vasp -dim 3
    mv PLANAR_AVERAGE.dat PLANAR_AVERAGE_CHARGE.dat
    vaspkit -task 426 -dim 3

    cd ../
    cd n$i

    echo -e "314\nCHGCAR ../../$A/CHGCAR" `echo ../../$B*`'/CHGCAR' | vaspkit
    vaspkit -task 316 -file CHGDIFF.vasp -dim 3
    mv PLANAR_AVERAGE.dat PLANAR_AVERAGE_CHARGE.dat
    vaspkit -task 426 -dim 3

    cd ../
} &
done
wait

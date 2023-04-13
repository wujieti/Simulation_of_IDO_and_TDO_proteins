#!/bin/bash

export CUDA_VISIBLE_DEVICES="0"
pmemd.cuda -O -i min1.in -p 5TI9_solv.prmtop -c 5TI9_solv.inpcrd -ref 5TI9_solv.inpcrd -r cmp_min1.rst -o cmp_min1.out
pmemd.cuda -O -i min2.in -p 5TI9_solv.prmtop -c cmp_min1.rst -ref 5TI9_solv.inpcrd -r cmp_min2.rst -o cmp_min2.out
pmemd.cuda -O -i min3.in -p 5TI9_solv.prmtop -c cmp_min2.rst -ref 5TI9_solv.inpcrd -r cmp_heat0.rst -o cmp_min3.out

num=1
mu=0
enu=1
emu=0
while (( $num < 8 ))
do
pmemd.cuda -O -i heat$num.in -p 5TI9_solv.prmtop -c cmp_heat$mu.rst -ref 5TI9_solv.inpcrd -r cmp_heat$num.rst -o cmp_heat$num.out -x cmp_heat$num.mdcrd 
gzip -9 cmp_heat$num.mdcrd
echo "heat$num.in done"
let num+=1
let mu+=1
done
mv cmp_heat7.rst cmp_eq0.rst

while (( $enu < 101 ))
do
pmemd.cuda -O -i eq1.in -p 5TI9_solv.prmtop -c cmp_eq$emu.rst -ref 5TI9_solv.inpcrd -r cmp_eq$enu.rst -o cmp_eq$enu.out -x cmp_eq$enu.mdcrd
#gzip -9 cmp_eq$enu.mdcrd
let enu+=1
let emu+=1
done


#!/bin/bash

args=("$@")

#check the correct num of args
if [[ ${#args[@]} == 0 ]] || [[ ${#args[@]} > 2 ]]; then
  echo "create_ASMDinputs.sh {NUM of trajectories} {NUM of MDsteps}"
  exit
fi

num_asmd_sim=${args[0]}
mdsteps=${args[1]}

#create the ASMD directories
counter=1
for ((counter=1; counter<=$num_asmd_sim; counter++)); do
  if [ ! -d ASMD_$counter ]; then
    mkdir ASMD_$counter
  fi
done

#create the distance RST files
start_distance=8
end_distance=10
for stage in {1..15}; do
    cat >>dist.RST.dat.$stage<<EOF
 &rst
        iat=-1,-1,
        iresid=1,
        igr1=1391,0,
        igr2=1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,1399,0,
        grnam1(1)='C2C',
        grnam2(1)='N1',
        grnam2(2)='C1',
        grnam2(3)='C3',
        grnam2(4)='N2',
        grnam2(5)='C2',
        grnam2(6)='C4',
        grnam2(7)='C5',
        grnam2(8)='C6',
        grnam2(9)='C7',
        grnam2(10)='C8',
        grnam2(11)='C9',
        grnam2(12)='C10',
        grnam2(13)='C11',
        grnam2(14)='C12',
        grnam2(15)='C13',
        grnam2(16)='C14',
        grnam2(17)='C15',
        grnam2(18)='C16',
        grnam2(19)='C17',
        grnam2(20)='C18',
        grnam2(21)='F1',
        grnam2(22)='O1',
        r2=$start_distance,
        r2a=$end_distance,
        rk2=8,
 &end

EOF
  start_distance=$((start_distance+2))
  end_distance=$((end_distance+2))
done


#create the MDIN inputs & dist RST files for the ASMD simulation
for ((counter=1; counter<=$num_asmd_sim;counter++));do
  start_distance=8
  end_distance=10
  for stage in {1..15};do
    cat >>asmd_$counter.$stage.mdin<<EOF
ASMD simulation
 &cntrl
   ntxo=1,ioutfm=0,
   imin = 0, nstlim = $mdsteps, dt = 0.002,
   ntx = 1, temp0 = 310.0,
   ntt = 3, gamma_ln=5.0
   ntc = 2, ntf = 2, ntb =1,
   ntwx = 2500, ntwr = $mdsteps, ntpr = 2500,
   cut = 10, ig=-1, 
   irest = 0, jar=1, 
 /
 &wt type='DUMPFREQ', istep1=2500 /
 &wt type='END'   /
DISANG=dist.RST.dat.$stage
DUMPAVE=asmd_$counter.work.dat.$stage
LISTIN=POUT
LISTOUT=POUT
EOF
  mv asmd_$counter.$stage.mdin ASMD_$counter/
  cp dist.RST.dat.* ASMD_$counter/      
  done
done


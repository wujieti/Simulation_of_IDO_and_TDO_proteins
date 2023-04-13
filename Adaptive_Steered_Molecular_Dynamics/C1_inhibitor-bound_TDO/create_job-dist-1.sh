#!/bin/bash

args=("$@")

#check the correct num of args
if [[ ${#args[@]} == 0 ]] || [[ ${#args[@]} < 3 ]]; then
  echo "create_ASMDjobfile.sh {NUM of trajectories} {Coord/RST7} {Stage Num}"
  exit
fi

num_asmd_sim=${args[0]}

if [ ! -f ${args[1]} ]; then
  echo The file ${args[1]} does not exist
else
  coord=${args[1]}
  
fi

stage=${args[2]}

counter=1
for ((counter=1; counter<=$num_asmd_sim; counter++));do 

cat >>job.sh.$counter.$stage<<EOF
#!/bin/sh
export CUDA_VISIBLE_DEVICES="1"
pmemd.cuda -O -i ASMD_$counter/asmd_$counter.$stage.mdin -p c.prmtop -c c.rst -r ASMD_$counter/ASMD_$counter.$stage.rst7 -o ASMD_$counter/ASMD_$counter.$stage.mdout -x ASMD_$counter/ASMD_$counter.$stage.nc -inf ASMD_$counter/ASMD_$counter.$stage.info 

EOF
done


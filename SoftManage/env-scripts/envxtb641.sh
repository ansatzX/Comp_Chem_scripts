#!/bin/bash
PATH=/home/ansatz/soft/xtb-6.4.1/bin:$PATH
XTBPATH=/home/ansatz/soft/xtb-6.4.1/share/xtb
OMP_NUM_THREADS=8
MKL_NUM_THREADS=8
OMP_STACKSIZE=1000m
ulimit -s unlimited
echo "loading xTB 641"

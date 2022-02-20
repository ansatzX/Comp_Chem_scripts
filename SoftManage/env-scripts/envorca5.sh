#!/bin/bash
source /home/ansatz/soft/scripts/envopenmpi411.sh
PATH=/home/ansatz/soft/orca502:$PATH
LD_LIBRARY_PATH=/home/ansatz/soft/orca502:$LD_LIBRARY_PATH
alias orca502=/home/ansatz/soft/orca502/orca
echo "loading ORCA502"
echo "if you try to call xTB by Orca, please load xTB then"
echo "using alias orca502 as orca parallel run command"

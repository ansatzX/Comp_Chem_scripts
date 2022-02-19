

WORKDIR=/c/chemjobs/tmp/zbd/scan-exa/bash_scirpts2yourdata/scan-dihedral
cd $WORKDIR
mkdir DONE
mkdir INPUT
mkdir WRONG


mv *gjf INPUT

runprog=g16
echo "$runprog"  >> Report.log
# run jobs
cd INPUT
# no need 
#sed -i 's/%oldchk=OK.chk/!%oldchk=OK.chk/g' $(ls *.gjf|sort|head -n 1 )
for inf in $(ls ./*.gjf|sort) ;do
    cd $WORKDIR
    # get input
    mv  INPUT/${inf}  .
    # run it
    echo " calc ${inf}, run it"  >> Report.log
    ${runprog}   ${inf}  
    # judge it 
    iscov=$(grep Normal ${inf/.gjf/}.out)
    echo "done calc, judging"  >> Report.log
    if [[ -n ${iscov} ]];then
        echo  "${inf} OK"  >> Report.log
        mv ${inf/.gjf/}.out ./DONE
        mv ${inf} DONE
        cp INPUT.chk  ./DONE/${inf/.gjf/}.chk
        mv INPUT.chk  OK.chk

    else
        echo "${inf} using other way"  >> Report.log
        # backup bad chk for user to check
        mv INPUT.chk ./WRONG/${inf/.gjf/}.chk
        # guess why  it was wrong,try to solve

        isscf=$(grep "Convergence failure -- run terminated"  ${inf/.gjf/}.out)
        isopt=$(grep "Optimization stopped"  ${inf/.gjf/}.out)
        echo " isscf ${isscf}, isopt ${isopt}" >> Report.log
        if [[  -n ${isscf}   ]];then
            echo "scf problem, using XQC " >>Report.log
            sed -i 's/#p/#p scf=xqc/g' ${inf}
        elif [[ -n ${isopt} ]];then
            echo "opt problem, using gdiis" >> Report.log
            sed -i 's/opt=modredundant/opt=(modredundant,gdiis)/g' ${inf}
        else
            echo "sorry,check your files " >> Report.log
            exit
        fi

        mv ${inf/.gjf/}.out ./WRONG
        ${runprog} ${inf}  ${inf/.gjf/}.out

        # solution works? judge it       
        iscov=$(grep Normal "${inf/.gjf/}".out)
        if [[ -n ${iscov} ]];then
            # OK ,just backup OK file ,and prepare .CHk,for next point
            echo  " ${inf} OK now, althouth we use solution, run last frame stable=opt, if XQC"  >> Report.log
            mv ${inf/.gjf/}.out ./DONE
            mv ${inf} ./DONE
            cp INPUT.chk  ./DONE/${inf/.gjf/}.chk
            mv INPUT.chk  OK.chk

        else
            # Wrong，chekck your INPUT
            echo " ${inf} dead, please reset your scan variable or input keywords, you are rebirth" >> Report.log
            mv  ${inf} WRONG
            mv  ${inf/.gjf/}.out  WRONG
            mv INPUT.chk   ./WRONG/${inf/.gjf/}.chk

            exit
        fi

    fi

done

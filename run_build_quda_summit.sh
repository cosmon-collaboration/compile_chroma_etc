#!/bin/bash -l

#BSUB -P NPH162
#BSUB -W 120
#BSUB -nnodes 1
#BSUB -alloc_flags smt4
#BSUB -J compile_QUDA
#BSUB -u walkloud@lbl.gov

cd /ccs/proj/nph162/software/summit_mdwf_hisq

./build_quda.sh


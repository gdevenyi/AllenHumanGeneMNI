#!/bin/bash
set -euo pipefail

export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=${THREADS_PER_COMMAND:-$(nproc)}

movingfile=$1
fixedfile=$2
outputdir=$3
shift 3

fixedmask=$(dirname ${fixedfile})/$(basename ${fixedfile} _t1.nii.gz)_mask.nii.gz
movingmask=$(dirname $movingfile)/$(basename $movingfile _t1.nii.gz)_mask.nii.gz
movingfile2=$(dirname $movingfile)/$(basename $movingfile _t1.nii.gz)_t2.nii.gz
fixedfile2=$(dirname $fixedfile)/$(basename $fixedfile _t1.nii.gz)_t2.nii.gz



antsRegistration --dimensionality 3 --float 0 --collapse-output-transforms 1 --verbose -n BSpline[5] \
  --output [${outputdir}/$(basename ${movingfile})-$(basename ${fixedfile}),${outputdir}/$(basename ${movingfile}).Warped.nii.gz] \
  --use-histogram-matching 0 \
  --initial-moving-transform registrations4/$(basename ${movingfile})-$(basename ${fixedfile})1Warp.nii.gz \
  --initial-moving-transform registrations4/$(basename ${movingfile})-$(basename ${fixedfile})0GenericAffine.mat \
  --transform SyN[0.1,3,0] --metric CC[${fixedfile},${movingfile},1,6] --metric CC[${fixedfile2},${movingfile2},1,6] \
  --convergence [500x500x500x500x500x500x500x500x500x500x500x500x500x500x500x500x500x500,1e-7,10] \
  --shrink-factors 4x4x4x4x4x4x4x4x4x4x4x4x4x4x4x2x1x1 \
  --smoothing-sigmas 6.7945744023041525x6.369913502160143x5.945252602016134x5.520591701872124x5.095930801728114x4.671269901584105x4.2466090014400955x3.8219481012960856x3.3972872011520763x2.972626301008067x2.547965400864057x2.1233045007200477x1.6986436005760381x1.2739827004320285x0.8493218002880191x0.42466090014400953x0.21233045007200477x0mm \
  --masks [$fixedmask,$movingmask]

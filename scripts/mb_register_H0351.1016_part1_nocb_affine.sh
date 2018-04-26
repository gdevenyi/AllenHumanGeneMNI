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

if [[ ! -e ${outputdir}/$(basename ${movingfile})-$(basename ${fixedfile})0GenericAffine.mat ]]
then
antsRegistration --dimensionality 3 --float 0 --collapse-output-transforms 1 --verbose \
  --output [${outputdir}/part1,${outputdir}/$(basename ${movingfile}).Affine.nii.gz] \
  --use-histogram-matching 0 \
  --initial-moving-transform [${fixedfile},${movingfile},1] \
  --transform Rigid[0.5] \
  --metric Mattes[${fixedfile},${movingfile},1,32,Regular,1] \
  --metric Mattes[${fixedfile2},${movingfile2},1,32,Regular,1] \
  --convergence [409600x51200x6400,1e-8,10] \
  --shrink-factors 16x8x4 \
  --smoothing-sigmas 6.7945744023041525x3.3972872011520763x1.6986436005760381mm \
  --transform Similarity[0.1] \
  --metric Mattes[${fixedfile},${movingfile},1,64,Regular,1] \
  --metric Mattes[${fixedfile2},${movingfile2},1,64,Regular,1] \
  --convergence [51200x6400x800,1e-8,10] \
  --shrink-factors 8x4x2 \
  --smoothing-sigmas 3.3972872011520763x1.6986436005760381x0.8493218002880191mm \
  --transform Affine[0.1] \
  --metric Mattes[${fixedfile},${movingfile},1,128,Regular,1] \
  --metric Mattes[${fixedfile2},${movingfile2},1,128,Regular,1] \
  --convergence [6400x800x100,1e-8,10] \
  --shrink-factors 4x2x1 \
  --smoothing-sigmas 1.6986436005760381x0.8493218002880191x0.42466090014400953mm \
  --transform Affine[0.05] \
  --metric Mattes[${fixedfile},${movingfile},1,256,Regular,1] \
  --metric Mattes[${fixedfile2},${movingfile2},1,256,Regular,1] \
  --convergence [800x100x100x100,1e-8,10] \
  --shrink-factors 2x1x1x1 \
  --smoothing-sigmas 0.8493218002880191x0.42466090014400953x0.21233045007200477x0mm \
  --masks [$fixedmask,$movingmask]
fi

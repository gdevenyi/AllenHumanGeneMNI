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
cbmask=templates/templates2/cb.nii.gz

if [[ ! -e ${outputdir}/$(basename ${movingfile})-$(basename ${fixedfile})0GenericAffine.mat ]]
then
antsRegistration --dimensionality 3 --float 0 --collapse-output-transforms 1 --verbose -n BSpline[5] \
  --output [${outputdir}/$(basename ${movingfile})-$(basename ${fixedfile}),${outputdir}/$(basename ${movingfile}).Affine.nii.gz] \
  --use-histogram-matching 0 \
  --initial-moving-transform [${fixedfile},${movingfile},1] \
  --transform Affine[0.1] \
  --metric Mattes[${fixedfile},${movingfile},1,128,Regular,1] \
  --metric Mattes[${fixedfile},${movingfile2},1,128,Regular,1] \
  --convergence [500x500x500x500x500x500x500x500x500x500x500x500x500x500x500,1e-7,10,1] \
  --shrink-factors 4x4x4x4x4x4x4x4x4x4x4x4x2x1x1 \
  --smoothing-sigmas 13.0x12.0x11.0x10.0x9.0x8.0x7.0x6.0x5.0x4.0x3.0x2.0x1.0x0.5x0vox \
  --masks [$cbmask,registrations5/cblabel.nii.gz]
fi

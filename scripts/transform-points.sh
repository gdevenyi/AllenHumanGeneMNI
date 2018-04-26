#!/bin/bash

set -euo pipefail

tmpdir=$(mktemp -d)


#for file in /data/chamal/projects/steele/working/AllenBrain_coords/*_LPS_x-z-y.csv; do

#H0351.2003 H372.0006 don't have data!

#XYZ must be in LPS coordinates
for subject in H0351.1009 H0351.1012 H0351.1015 H0351.2001 H0351.2002; do

  file=AllenBrain_coords/${subject}_SampleAnnot_mm_coor_LPS_x-z-y.csv
  echo x,y,z,t,label > $tmpdir/$(basename $file)
  awk -vFPAT='([^,]*)|("[^"]+")' -v OFS=','  '{print $14,$15,$16,0,$3}' $file | tail -n +2 >> $tmpdir/$(basename $file)
  antsApplyTransformsToPoints -i $tmpdir/$(basename $file) -o transformed-points/$(basename $file) -d 3 -t [$(ls registrations/*/${subject}_t1.nii.gz-model_extracted_t1.nii.gz0GenericAffine.mat),1] \
  -t $(ls registrations/*/${subject}_t1.nii.gz-model_extracted_t1.nii.gz1InverseWarp.nii.gz) --precision 1
done

for subject in H0351.1016; do
  file=AllenBrain_coords/${subject}_SampleAnnot_mm_coor_LPS_x-z-y.csv
  echo x,y,z,t,label > $tmpdir/$(basename $file)
  awk -vFPAT='([^,]*)|("[^"]+")' -v OFS=','  '{print $14,$15,$16,0,$3}' $file | tail -n +2 >> $tmpdir/$(basename $file)
  antsApplyTransformsToPoints -i $tmpdir/$(basename $file) -o transformed-points/$(basename $file) -d 3 -t [$(ls registrations/*/${subject}_t1.nii.gz-model_extracted_t1.nii.gz0GenericAffine.mat),1] \
  -t $(ls registrations/*/${subject}_t1.nii.gz-model_extracted_t1.nii.gz2InverseWarp.nii.gz) -t $(ls registrations/*/part21InverseWarp.nii.gz)  --precision 1

done

rm $tmpdir/*.csv

for file in transformed-points/*csv; do
    cut -d"," -f 1-3 $file > $tmpdir/$(basename $file)
    echo "mni_nlin_x,mni_nlin_y,mni_nlin_z" > $(dirname $file)/$(basename $file _mm_coor_LPS_x-z-y.csv)_RAS_mni_nonlin.csv
    tail -n +2 $tmpdir/$(basename $file)| awk -F "," -v OFS="," -v CONVFMT=%.17g '{$1=-1*$1;$2=-1*$2;$3=$3; print}' >> $(dirname $file)/$(basename $file _mm_coor_LPS_x-z-y.csv)_RAS_mni_nonlin.csv
    rm $file
done

rm -rf $tmpdir

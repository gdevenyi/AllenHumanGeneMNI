for file in minc/input-classes/final/{1,2,3}/*t1.nii.gz; do
  if [[ ! -s registrations/class123/$(basename $file).Warped.nii.gz ]]; then
    echo ./mb_register_class123.sh $file templates/templates2/model_extracted_t1.nii.gz registrations/class123
  fi
done
for file in minc/input-classes/final/4/*t1.nii.gz; do
  if [[ ! -s registrations/class4/$(basename $file).Warped.nii.gz ]]; then
  echo ./mb_register_class4.sh $file templates/templates2/model_extracted_t1.nii.gz registrations/class4
  fi
done

echo ./mb_register_H0351.1016_part1_nocb_affine.sh minc/input-classes/final/2/weird/H0351.1016_nocb_t1.nii.gz templates/templates2/model_extracted_nocb_t1.nii.gz registrations/weird
echo ./mb_register_H0351.1016_part2_nonlin_cbonly.sh minc/input-classes/final/2/weird/H0351.1016_cbonly_t1.nii.gz templates/templates2/model_extracted_cbonly_t1.nii.gz registrations/weird
echo ./mb_register_H0351.1016_part3_nonlin_aftercb.sh minc/input-classes/final/2/weird/H0351.1016_t1.nii.gz templates/templates2/model_extracted_t1.nii.gz registrations/weird

for file in *.csv; do

echo """MNI Tag Point File
Volumes = 1;

Points = """ > $(basename $file .csv).tag

tail -n +2 $file | awk -v FPAT="([^,]+)|(\"[^\"]+\")" -v OFS=" " '{print $14,$15,$16,1,$3,1,$3}' >> $(basename $file .csv).tag

echo ";" >> $(basename $file .csv).tag

done

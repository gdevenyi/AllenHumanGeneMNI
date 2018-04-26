for file in ../microarray/*/SampleAnnot.csv; do


paste -d"," $file $(basename $(dirname $file))_SampleAnnot_RAS_mni_nonlin.csv > recombine/$(basename $(dirname $file))_SampleAnnot.csv

#paste -d"," $file $(basename $file) > recombine/$(basename $file)

done

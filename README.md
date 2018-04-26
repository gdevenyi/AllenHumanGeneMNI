# AllenHumanGeneMNI
Careful multispectral registration of the Allen Human Brain Gene Samples in MNI ICBM NLIN SYM 09c space

This set of scripts and data is a re-registration of the Allen Human Brain MRIs
http://human.brain-map.org/mri_viewers/data
In order to transform the voxel coordinates of gene samples:
http://human.brain-map.org/static/download
into MNI space.

Steps done on the data:
- Convert to MINC
- Bias field correct via the sqrt(T1/T2) method
- Additional bias field correction via tissue-class N4BiasFieldCorrection
- Conversion back to NIFTI
- Registration using supersampled affine and non-linear SyN using antsRegistration using brain masks
- Specal-case registration of H0351.1016 by
  - masking out of the cerebellum in MNI and subject followed by affine registration
  - non-linear registration of the subject cerebelum to the MNI cerebellum
  - non-linear registraiton of the while brain subject to the whole brain MNI


Output data available is
- linear and nonlinear transforms from "native" allen brains to MNI space
- modified SampleAnnot.csv file with new mni coordinates per probe
- MNI Tag point files (https://en.wikibooks.org/wiki/MINC/SoftwareDevelopment/Tag_file_format_reference) for each subject/probe

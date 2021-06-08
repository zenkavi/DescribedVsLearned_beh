
Initial command to explore DICOM structures and specify the `heuristics` file.

**IMPORTANT**: If you're using zsh, which is the new default on Mac Terminals you need to include `noglob` before running the docker image so it interprets the `*` wildcards correctly.

```
noglob docker run --rm -it -v /Users/zeynepenkavi/Downloads/GTavares_2017_arbitration:/base nipy/heudiconv:latest \
-d /base/raw_fMRI_data/AR-GT-BUNDLES-{subject}_RANGEL/*/*/*.IMA \
-o /base/Nifti/ \
-f convertall \
-s 03 \
-c none --overwrite
```

Command to get all subjects' ages from dicoms

```
noglob docker run --rm -it -v /Users/zeynepenkavi/Downloads/GTavares_2017_arbitration:/base nipy/heudiconv:latest \
-d /base/raw_fMRI_data/AR-GT-BUNDLES-{subject}_RANGEL/*/LOCALIZER_*/*.IMA \
-o /base/Nifti/ \
-f convertall \
-s 02 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 22 23 24 25 27 \
-c none --overwrite
```

Command to convert dicoms of one subject into BIDS

```
noglob docker run --rm -it -v /Users/zeynepenkavi/Downloads/GTavares_2017_arbitration:/base -v /Users/zeynepenkavi/Documents/RangelLab/DescribedVsLearned:/code nipy/heudiconv:latest \
-d /base/raw_fMRI_data/AR-GT-BUNDLES-{subject}_RANGEL/*/*/*.IMA \
-b -o /base/Nifti/ \
-f /code/bidsify/heuristic.py \
-s 01 \
-c dcm2niix --overwrite
```
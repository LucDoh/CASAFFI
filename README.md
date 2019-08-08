# Cell Analysis & Segmentation Framework for Fluorescent Images

CASFFI is a cell segmentation and analysis code written in Matlab to obtain Delta F/F
traces from a TIF stack of fluorescent images, and infer spiking activity from the
identified cells. runAll.m calls the scripts which each perform some process (pre-process,
segmentation, background subtraction and mapping electrical activity from the change in
fluorescence).

To run:
runAll('../data/6e6ACSF_0ms_3_MMStack.tif',70,2000,0.7,70)

where here the TIF stack to analyze is named "6e6ACSF_0ms_3_MMStack.tif", and is found in
a directory named data one directory above.

More details at the top of runAll.m. 
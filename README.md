# cellSegmentation-Analysis

This is a cell segmentation and analysis code written in Matlab for obtaining Delta F/F
traces from a TIF stack of fluorescent images, and infer electrical activity of the
identified cells. Running runAll.m will run the scripts in order to pre-process, segment
cells, perform background subtraction, infer electrical activity on a cell-by-cell basis,
and then visualize the electrical activity of the cells.

To run:
runAll('../data/6e6ACSF_0ms_3_MMStack.tif',70,2000,0.7,70)

where here the TIF stack to analyze is named "6e6ACSF_0ms_3_MMStack.tif", and is found in
a directory named data one directory above.

More details at the top of runAll.m:

% -- Main script V6 --
% Runs framework for preprocessing, segmentation, computing delta_f/f and
% visualization to extract from fluorescent images electrical activity of
% cells dyed with BeRST.

% Example usage: runAll('../data/6e6ACSF_0ms_3_MMStack.tif',70,2000,0.7,70)

% This has been tested on HEK-NK_ACSF_2018_08_31.tif, 6e6ACSF_0ms_3_MMStack.tif.

% *fname: name of TIF stack. 
% *minSize/maxSize bound the size (in pixels) of the identified cells.
% *sens: threshold of binarization: higher means more will be 1, thus 
% more boundaries/walls, and  more smaller cells identified BUT biased towards
% *overidentifying [0.5-0.8]
% *threshold: the % cutoff for a 'firing frame' in preprocessing. The lower
% this is, the more frames are averaged over for segmentation img [20-90]

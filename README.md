# Cell Analysis & Segmentation Framework for Fluorescent Images

CASAFFI is a cell segmentation and analysis code written in Matlab to infer electrical activity of cells using BeRST, a voltage-sensitive dye.


Increases in voltage in cells are reflected by an increase in fluorescence in BeRST, F, and can be directly captured by the linear relationship with (Delta F/ F). This means we can use take stacks of fluorescent images with a microscope at high framerate and resolution, process these images, and see neurons fire.


Delta F/F traces are constructed from a TIF stack of fluorescent images and after several steps, we infer and visualize the electrical activity from the cells. We can then use a rule-based method when working with neurons to label spikes, AKA neuronal firing.   


Steps:
1) Pre-processing the image
2) Segmentation (identify each cell object)
3) Background subtraction
4) Mapping electrical activity in cells from change in fluorescence
5) Visualizing this activity




runAll.m calls the scripts which each perform each step. 



To run:
runAll('../data/6e6ACSF_0ms_3_MMStack.tif',70,2000,0.7,70)

where here the TIF stack to analyze is named "6e6ACSF_0ms_3_MMStack.tif", and is found in
a directory named data one directory above.

More details at the top of runAll.m. 

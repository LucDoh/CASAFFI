# Cell Analysis & Segmentation for Fluorescent Images

CASFI is a cell segmentation and analysis code written in Matlab to infer electrical activity of cells from fluorescent images.
This assumes you are using a voltage-sensitive dye like BeRST, where intensity is proportional to voltage.

Increases in voltage in cells are reflected by a linear increase in fluorescence in BeRST, (Delta F/ F). With high resolution and fast enough framerates, this can be used to see neurons fire.


After segmentation and background subtraction, Delta F/F traces are made from a (TIF) stack of fluorescent images and after several steps, we infer and visualize the electrical activity from the cells. We can then use a rule-based method (e.g. z-score > 1.5) to label spikes when looking at neurons, AKA neuronal firing.   


### Steps:
1) Pre-process the image
2) Segmentation (identify each cell object)
3) Background subtraction
4) Map electrical activity in cells from change in fluorescence
5) Visualize activity



### Running:  

Run by calling the main script which itself will runs individual steps:  

_**runAll('../data/6e6ACSF_0ms_3_MMStack.tif',70,2000,0.7,70)**_

which points to the TIF stack *6e6ACSF_0ms_3_MMStack.tif* and passes image processing parameters.

Details and comments in runAll.m...

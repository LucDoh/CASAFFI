% This has been tested and works pretty well on 
% HEK-NK_ACSF_2018_08_31.tif, TIF stack from HEK
% cells with BeRST dye on the spinning disk.
% minSize and maxSize are bounds on the sizes in
% pixels, for cells to be segmented.

%What is cellsize, FOV. Use that to create limits on size.
function s = runAll(fname, minSize, maxSize, sens)
if(maxSize == 0)
    minSize = 500;
    maxSize = 3000;
end

avgfName = preProcess(fname);
[L, n] = segmentL(avgfName,minSize,maxSize, sens);%('segmentationCode/seg_Skel_Qixin.tif',minSize,maxSize);
csvName = usingSegmAnalysis(fname,L);
plot_fCells(csvName);
hotNCells(csvName, L, 10);
end

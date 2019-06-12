% -- Main script V6 --
% Runs framework for preprocessing, segmentation, computing delta_f/f and
% visualization to extract from fluorescent images electrical activity of
% cells dyed with BeRST.

% Example usage: runAll('../data/6e6ACSF_0ms_3_MMStack.tif',70,2000,0.7,70)

% This has been tested on HEK-NK_ACSF_2018_08_31.tif, 6e6ACSF_0ms_3_MMStack.tif.

% *fname: name of TIF stack with fluorescent images
% *minSize/maxSize bound the size (in pixels) of the identified cells.
% *sens: threshold of binarization: higher means more will be 1, thus
% more boundaries/walls, and  more smaller cells identified BUT biased towards
% *overidentifying [0.5-0.8]
% *threshold: the % cutoff for a 'firing frame' in preprocessing. The lower
% this is, the more frames are averaged over for segmentation img [20-90]

function s = runAll(fname, minSize, maxSize, sens, threshold)

  % minSize = 500, maxSize = 3000, sens=0.6 work well for spinning disk

  % STEP 1 - Preprocess and make an "average firing image". If there exists a
  % better quality imagestack of the same FOV as fname, this can be passed here instead.
  avgfName = preProcess(fname, threshold);
  % STEP 2 - Segmentation using the "average firing image"
  [L, n, L_holes, csvName_Centr] = segmentL(avgfName,minSize, maxSize, sens);

  m=input(strcat(int2str(n),' cell have been found, would you like to continue analysis? [y/n]'),'s');
  if m=='n', return; end

  % STEP 3 - Get fluorescent traces, perform bgd subtraction
  fcsvName = usingSegmAnalysis(fname, L, L_holes);
  % STEP 4 - Compute DF/Fs, outputs csv of DF/F and plots.
  dFF_csvName = plot_dFF(fcsvName, 50); %15 frame moving average
  hotCellList = hotNCells(fcsvName, L, int16(n/10)); % STEP 5
  display(hotCellList);
  % STEP 6 - Spike inference using z-score of 1.5 and above
  % Third argument of m means every m cells are shown in spike raster plot.
  [~,csv_Spikes] = getSpikes(dFF_csvName, 2, 1); %m=3

  % STEP 7 - Finally, make a video of cell spiking activity. This takes a
  % while, so worth commenting out when testing stuff, Also this is a WIP.
  v=input('Would you like to make a video of firing? [y/n]','s');
  if v=='y', makeViz(csvName_Centr, csv_Spikes); end
end

% STEP 1: Preprocessing
% Create and save an image of the average "firing" frame, where 'firing' is
% defined if the avg Intesity of the frame is above some threshold "thresh".
% This should help give better outlines for the cells for segmentation.

%Define tif file & name for new image
%clear
%fname = 'BeRST_Tifs/BeRST_1Long-STIM10V_1x1_14msExpo_1.tif';
%preProcess(fname)

function s = preProcess(fname, threshold)
  avgfName = strcat(erase(fname,'.tif'), '_AvgFiring.tif');
  s = avgfName;
  subtract_Min = true;

  iStack = getImgStack(fname);
  imwrite(mat2gray(iStack(:,:,1)),strcat(erase(fname,'.tif'), '_frame1.tif'))
  sz = size(iStack)
  numFrames = sz(3);

  %Create 1D array of the average intensity for each frame
  avgIntensity_perFrame = zeros(1,sz(3));
  for t=1:sz(3)
      avgIntensity_perFrame(t) = mean2(iStack(:,:,t));
  end
  minimumAvg = min(avgIntensity_perFrame);

  %Subtract "baseline" frame, minimum intensity frame ->
  if(subtract_Min)
    avgIntensity_perFrame = avgIntensity_perFrame - minimumAvg;
  end
  %Get value s.t. that 80% of the array is smaller %if t==0, t=70; end
  thresh = prctile(avgIntensity_perFrame, threshold);%80); %Leaving this at 0 is bad...
  avgFiringImage = zeros(sz(1),sz(2)); % 2D array that will be filled with avgs
  numF=0;
  for t=1:sz(3)
      if (avgIntensity_perFrame(t) > thresh)
          avgFiringImage = avgFiringImage + iStack(:,:,t);
          numF = numF+1;
      end
  end

  avgFiringImage = avgFiringImage/numF; %Normalize by number of frames stacked
  %avgFiringImage = imadjust(avgFiringImage);
  avgFiringImage = medfilt2(avgFiringImage);
  imwrite(mat2gray(avgFiringImage),avgfName);
   % Write to .tif file

  %Plotting:
  %imagesc(avgFiringImage); colormap('gray')
  %h = histogram(avgIntensity_perFrame,10)
  %p = plot(avgIntensity_perFrame)
  %size(avgIntensity_perFrame)
  %plot(avgIntensity_perFrame)
return

%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Returns a 3D array (x,y,t)
function [imgStack] = getImgStack(fname)
info = imfinfo(fname);
n = length(info);
imgStack = [];
for i=1:n
    img = imread(fname,i, 'Info', info);
    imgStack(:,:,i) = img;
end

end
end

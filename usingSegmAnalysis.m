% STEP 3: Compute delta(F)/F
% Using mask obtained from a TIF file idenmake csv where each line consists of comma-separated
% fluorescences per frame for a specific cell

% 1st - averaged bgd over all frames subtracted
% 2nd - frame by frame bgd subtraction
function csvName = usingSegmAnalysis(fname, L, L_holes)
  %fname = 'HEK-NK_ACSF_2018_08_31.tif';
  iStack = getImgStack(fname);
  sz = size(iStack);
  numFrames = sz(3);
  f_i = iStack(:,:,1); %Initial fluorescence

  % What if implement background subtraction frame-by-frame before computing
  % DeltaF/F (04/15/19)
  booTest = false;
  if booTest==true
      for i = 1:numFrames
          A = iStack(:,:,i); A = imadjust(mat2gray(A));
          bgd = imopen(A,strel('disk',15)); iStack(:,:,i) = A-bgd;
      end
      figure;
      imshowpair(f_i, iStack(:,:,1),'montage')
      title('Bgd subtracted vs not');
  end
  %%%%%%%%%%Get mask from Fogbank-segmentation%%%%%%%%%%%%%%%%%%%
  %iMask = imread('segm_HEK-NK_ACSF_2018_08_31_AvgFiring.tif');
  %saveas(gcf,'segmented_Colors.jpg')

  % Get fluorescence per frame for each celland for each background region
  f_cells_t = calcFperCell(numFrames, L, iStack);
  % Two methods of background subtraction, yielding:
  % 1) f_background_t and 2) f_bgd_iter
  f_holes_t = calcFperCell(numFrames, L_holes, iStack);
  f_background_t = min(f_holes_t); %was mean()

  p=0.05; %This is the percentile for which we will define background.
  f_bgd_iter = zeros(1,numFrames);
  for j = 1:numFrames
      ij = iStack(:,:,j);
      f_bgd_iter(j) = prctile(ij(:), p);
  end
  f_background_t_p = prctile(f_holes_t, p,1);

  %PLOTTING
  figure
  plot(f_background_t)
  title(['Min background F'])
  figure
  plot(f_background_t_p)
  title(['pth Percentile background F'])
  figure
  plot(f_bgd_iter)
  title(['pth Percentile (iter) background F'])
  figure
  plot(max(f_cells_t))
  title(['Max Cell F'])
  figure
  plot(max(f_cells_t))
  title(['Mean Cell F'])
  figure
  plot(f_cells_t')
  title(['All Cell F'])

  % Testing, if !work revert f_cells_t:
  % Subtract the average background fluorescence per fram e
  out = bsxfun(@minus,f_cells_t,f_bgd_iter);%f_background_t);
  f_cells_t = out;

  %Use sample std and standardize along rows
  %z_cells_t = zscore(f_cells_t(:));

  %csvwrite('Subrtacted-adhoc.csv', out);
  figure
  plot(f_cells_t')
  title(['All Cell F, bgd subtracted'])

  csvName = strcat('csvs/',erase(fname,'../data'));
  csvName = strcat(erase(csvName,'.tif'), '_f_t_cells.csv');
  csvwrite(csvName,f_cells_t);
  csvwrite('csvs/HEK-background_adhoc.csv',f_background_t);
end

%%%%%%%%%%%%HELPER FUNCTIONS%%%%%%%%%%%%%%%%%%
%Make image stack:
function [imgStack] = getImgStack(fname)
  info = imfinfo(fname);
  n = length(info);
  imgStack = [];
  for i=1:n
      img = imread(fname,i, 'Info', info);
      imgStack(:,:,i) = img;
  end

end

%Function to return only the indices corresponding to *membrane* of cell
function [rc2] = getMembrane(j, iMask, iStack)

 [r, c] = find(iMask==j); %finds all positions of cell "2"
 rc = [r c]; % Convert to 2D array where rc(i,1) + rc(i,2) is the ith position
 size(rc);
 linearidx = sub2ind(size(iMask),rc(:,1), rc(:,2));
 %iMask(linearidx) % This will get all cells which of the linearidx
 iStack_t1 = iStack(:,:,1);
 p = prctile(iStack_t1(linearidx),0); %68 percentile scalar (changed to 10 04/03/19)
 %hist(iStack_t1(linearidx), 10);

 [r2, c2] = ind2sub(size(iMask),find(iStack_t1(linearidx) >= p)); %Grabs the positions of top p
 rc2 = [r2 c2];
 size(rc2);
 %iStack_t1(sub2ind(size(iStack_t1),rc2(:,1),rc2(:,2)))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Using numCells, numFrame, IMask, iStack
function f_cells_t = calcFperCell(numFrames, iMask, iStack)

numCells = max(iMask(:)); %64

f_cells_t = zeros(numCells,numFrames); % 64 x 208
%f_t = zeros(1,numFrames);
size(f_cells_t);
numPositions = zeros(1,numCells);
for j=1:numCells %numCells % iterate over cells
    [r, c] = find(iMask==j); %finds all positions of cell "1"
    rc = [r c]; % Convert to 2D array where rc(i,1) + rc(i,2) is the ith position
    rc2 = getMembrane(j, iMask, iStack); %get top p percent of j positions
    %linearidx = sub2ind(size(iMask),rc(:,1), rc(:,2))

    sz2 = size(rc2);
    numPositions(j) = sz2(1);
    for t=1:numFrames %iterate over numframes
        for i=1:sz2(1) % iterate over all positions of cell j
           f_cells_t(j,t) = f_cells_t(j,t) + iStack(rc2(i,1),rc2(i,2),t);
           %f_t(t) = f_t(t) + iStack(rc(i,1),rc(i,2),t);
        end
        f_cells_t(j,t) = f_cells_t(j,t)/sz2(1); %Normalize by number of pixels
    end
end
end

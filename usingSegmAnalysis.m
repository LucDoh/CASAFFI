% STEP 3: Using mask from a segmented/labeled file,
% make csv where each line consists of comma-separated
% fluorescences per frame for a specific cell

function csvName = usingSegmAnalysis(fname, L)
%fname = 'HEK-NK_ACSF_2018_08_31.tif';
iStack = getImgStack(fname);
sz = size(iStack);
numFrames = sz(3);
f_i = iStack(:,:,1); %Initial fluorescence

%%%%%%%%%%Get mask from passed Label Matrix%%%%%%%%%%%%%%%%%%%
iMask = L;
%%%%%%%%%%Get mask from Fogbank-segmentation%%%%%%%%%%%%%%%%%%%
%iMask = imread('segm_HEK-NK_ACSF_2018_08_31_AvgFiring.tif');
%imagesc(iMask)

%saveas(gcf,'segmented_Colors.jpg')
% Do this for every cell, output plot.

numCells = max(iMask(:)); %64

f_cells_t = zeros(numCells,numFrames); % 64 x 208
f_t = zeros(1,numFrames);
size(f_cells_t);
numPositions = zeros(1,numCells);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:50 %numCells % iterate over cells
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
        f_cells_t(j,t) = f_cells_t(j,t)/sz2(1);
    end
end
 %f_t = f_t/sz2(1) % Normalized by number of pixels
 
csvName = strcat(erase(fname,'.tif'), '_f_t_cells.csv');
csvwrite(csvName,f_cells_t)
%csvwrite('HEK-Cell_f_t_cells_topP_B.csv',f_cells_t)

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
 p = prctile(iStack_t1(linearidx),68); %68 percentile scalar
 %hist(iStack_t1(linearidx), 10);

 [r2, c2] = ind2sub(size(iMask),find(iStack_t1(linearidx) > p)); %Grabs the positions of top p
 rc2 = [r2 c2];
 size(rc2);
 %iStack_t1(sub2ind(size(iStack_t1),rc2(:,1),rc2(:,2)))
end
%%%%%%%TESTING%%%%%%%%%

% Displays image to be segmented, then 
% binarizes, filters out too small and large
% objects, thickens lines and labels these. 
function [L,n] = segmentL(fname,minSize,maxSize,sens)
I = imread(fname);
A = mat2gray(I);
imshow(A);
% 1) Binarize by some threshold
img_bw2 = imbinarize(A,'adaptive', 'Sensitivity',sens);
img_bw_inv = imcomplement(img_bw2);
%imshow(imadjust(A))
%imshow(img_bw2)

% 2) Extract objects whose area is in some range of pixels
% Cells are roughly 5-10% of FOV, FOV=500x500 = 250000 pixels
BW2 = bwareafilt(img_bw_inv,[minSize maxSize]);%[500 3000]);

% 3) Thicken adds pixels to exterior of objects until doing so would results in
%objects being connected which weren't previously
%figure
%imshow(BW2)
SE = strel('disk',2);

bskel = bwmorph(BW2,'thick',5) - imerode(BW2,SE); %Could be made 10 resulting in a 1 pixel difference
bskel = bwareafilt(logical(bskel),[minSize*0.5 maxSize]);%[500 3000]);

% 4) Find and label objects
L = bwlabel(bskel);
figure
%imshowpair(BW2,bskel,'montage')%label2rgb(C, @jet, [.5 .5 .5]),'montage');
imshowpair(bskel,label2rgb(L, @jet, [.5 .5 .5]),'montage');
%imwrite(L,'segm_fromL.tif')

n = max(L(:));
disp(n);

end

% Just read in the image we got from Preprocessing
%I = imread('HEK-NK_ACSF_2018_08_31_AvgFiring.tif');
%I_f1 = mat2gray(imread('HEK-NK_ACSF_2018_08_31_frame1.tif'));
%Igray = mat2gray(I); %Make max value 1, min 0
%imshow(I); imhist(I);

%Watershed transform works well on Qixin's skeletonization of avgfiring
%bwareaopen(imread('seg_Skel_Qixin.tif'),10)
%img = imread('seg_Skel_Qixin.tif');
%img_bw = imbinarize(I_f1);


% %Find boundaries and show them
% figure
% [B,L] = bwboundaries(img_bw_inv);
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% return
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end
% %How many labels
% disp(length(B));
% disp(max(L(:)))

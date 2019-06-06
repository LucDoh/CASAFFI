% STEP 2: SEGMENTATION
% Displays image to be segmented, then removes background, binarizes, filters
% out too small and large objects, thickens lines and labels these. 
function [L,n, L_holes, csvName_Centr] = segmentL(fname,minSize,maxSize,sens)
I = imread(fname);
A = mat2gray(I);
figure 
imshow(A)
imgOG = A;

%Increase contrast and sharpen edges
A=imadjust(A);
B = imsharpen(A,'Radius',5,'Amount',2);
A=B; %For now
%A = edge(A,'sobel');

%Get background by removing objects which can't fit strel element
bgd = imopen(A,strel('disk',10)); %was 15
% figure
% imshow(bgd)
%imshowpair(A, imadjust(A-bgd),'montage')
A = imadjust(A-bgd);
%title('Enhanced, background subtracted image')

% 1) Binarize by user-defined threshold, then skel+spur+gaussian filter.
% Finally complement and label these objects "cells"

sensAuto = sens; %graythresh(A);
img_bw2 = imbinarize(A,'adaptive', 'Sensitivity',sensAuto);%sens);
img_bw2Bin = imbinarize(A,'adaptive','Sensitivity',0.8*sens);
figure
imshowpair(img_bw2, img_bw2Bin,'montage')
% Skeletonize, spurring and then gaussian filter to increase width of skels,
% this makes a big difference. - Thanks to Sylvester for help here.
img_bw2 = bwmorph(img_bw2,'skel',5); %was 4
img_bw2 = bwmorph(img_bw2, 'spur', 1);
img_bw2 = imgaussfilt(double(img_bw2),1);
img_bw_inv = imcomplement(logical(img_bw2));
Lnew=bwlabel(img_bw_inv);
figure
imshowpair(img_bw2,label2rgb(Lnew, @jet, [.5 .5 .5]),'montage')

% 2) Extract objects whose area is in some range of pixels
% TBA: Cells are roughly 5-10% of FOV, FOV=512x512 = 262144 pixels

BW2 = bwareafilt(img_bw_inv,[minSize maxSize]);%[500 3000]);
%img_holes = imbinarize(A,'adaptive', 'Sensitivity', 0.6);
BWHoles = bwareafilt(img_bw_inv,[maxSize*2 512*512/6]);
BWHoles = imerode(BWHoles,strel('disk',5));

% 3) Thicken adds pixels to exterior of objects until doing so would results in
% objects being connected which weren't previously (alt: could try using bwperim)
SE = strel('disk',2);%2);
bskel = bwmorph(BW2,'thick',8) - imerode(BW2,SE); %5? 20 over-extends membranes
bskel = bwareafilt(logical(bskel),[minSize*.5 maxSize]);%[500 3000]);

%bskel = bwperim(BW2); bskel = bwmorph(bskel,'thick',5); Perim doesn't work great

%3B) Save centroids of cell membranes.
s = regionprops(bskel, 'centroid');
csvName_Centr = strcat('csvs/',erase(erase(fname,'../data'),'_AvgFiring'));
csvName_Centr = strcat(erase(csvName_Centr,'.tif'), '_cellCentroids.csv');
csvwrite(csvName_Centr, cat(1, s.Centroid));

% 4) Find and label objects
L = bwlabel(bskel);
%L_holes = bwlabel(imerode(BWHoles,strel('disk',2)));
L_holes = bwlabel(BWHoles);
figure
%imshowpair(BW2,bskel,'montage')%label2rgb(C, @jet, [.5 .5 .5]),'montage');
imshowpair(img_bw2,label2rgb(L, @jet, [.5 .5 .5]),'montage');
figure
imshowpair(label2rgb(L_holes, @jet, [.5 .5 .5]),label2rgb(L, @jet, [.5 .5 .5]),'montage');
figure 
imshowpair(imgOG,label2rgb(L, @jet, [.5 .5 .5]),'montage');

green =zeros(size(A,1),size(A,2),3);
green(:,:,2)=1;
figure
imshow(A)
hold all
h=imshow(label2rgb(L, @jet, [1.0 1.0 1.0]))%[.5 .5 .5]));
set(h, 'AlphaData', bskel*0.6)

n = max(L(:));
disp(n);
end



% Old code and examples 

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
% %How many labelsc ds
% disp(length(B));
% disp(max(L(:)))

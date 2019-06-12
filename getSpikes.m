% STEP 6: SPIKE INFERENCE (basic)
% Using deltaF/F csv, compute zscore arrays for each cell.
% Then, using some z-score threshold, turn this into matrix of spikes and
% raster plot.
function [spikeMatrix, spikes_csvName] = getSpikes(dFF_csvName, zThresh, m)
  dFF_Matrix = csvread(dFF_csvName);
  z_Matrix = zeros(size(dFF_Matrix));

  for v = 1:size(dFF_Matrix,1)
      z_Matrix(v,:) = zscore(dFF_Matrix(v,:));
  end

  zBinary =  z_Matrix > zThresh;

  %subplot(1,2,1) %plot(zBinary(1:m:size(zBinary,1),:)');
  %plot(dFF_Matrix(1:5:size(zBinary,1),1:500)')

  % Raster plot of spikes
  %subplot(1,2,2)
  figure
  mat = 1- zBinary(1:m:size(zBinary,1),:); %zBinary([12, 27, 48, 54, 5]);
  [r, c] = size(mat);
  imagesc( (1:c), (1:r), mat); %imagesc((1:c)+0.5, (1:r)+0.5, mat)
  colormap(gray);
  title('Subset of cells, raster plot of spikes')
  xlabel('Frames')
  ylabel('Cells')
  set(gca,  ...  % 'XTick', 1:(c+1), 'YTick', 1:(r+1), Change some axes properties
           'XLim', [1 c+1], 'YLim', [1 r+1], ...
           'GridLineStyle', '--', 'YGrid', 'on');
  spikeMatrix = zBinary;
  spikes_csvName = strcat(erase(dFF_csvName,'_DFF.csv'),'_Spikes.csv');
  csvwrite(spikes_csvName,spikeMatrix);
end

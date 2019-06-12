% STEP 5: Get "hottest" cells:
% Given a label matrix L, csv of timeseries, and number of cells k,
% plot the k most active cells
function hotCellList = hotNCells(csvName, L, k)
  f_cells_t = csvread(csvName);

  [m,n] = size(f_cells_t);
  f_cells_t_Mov = zeros(m,n);


  for j = 1:m
      [f_o,delta_f,delta_f_Mov] = deltaFCalc(f_cells_t(j,:));
      f_cellMov_j = delta_f_Mov/f_o;
      f_cells_t_Mov(j,:) = f_cellMov_j;
  end
  %Make this a column of average activity by cell
  meanActivity = mean(f_cells_t_Mov,2);
  %Get max k elements and return their indices as I
  [B,I] = maxk(meanActivity, k);

  [x,y] = size(L);
  C = zeros(x,y);
  %size(L); size(C); disp(I)
  %Loop through k most active cells to plot them
  for l=1:k
      C(L==I(l))=1;
  end
  imshow(C);
  hotCellList = I;
  %imwrite('this.tif',C)
  %csvMov = strcat(erase(csvName,'.csv'), '_MovAvg.csv');
  %csvwrite(csvName,delta_f_Mov)
end



function [f_o,delta_f,delta_f_Mov] = deltaFCalc(f_t)
  %Calculate delta_f wrt first frame
  f_o = f_t(1);
  delta_f = f_t(:)-f_o;

  %Calculate delta_f wrt moving average 10 frames
  movAvg_f = movmean(f_t(:),10);
  delta_f_Mov = f_t(:) - movAvg_f;
end

% STEP 4: Plotting
% Using a csv which has rows representing cells and columns representing
% different times, whose elements are fluorescence
%clear;
%csvName = 'HEK-Cell_f_t_cells_topP_B.csv';
function n = plot_fCells(csvName)
    cells = [13, 14, 15, 26]; %Pick cells to be plotted
    figure
    for c=cells
        fPlot(c, csvName)
    end

end

function [] = fPlot(i, csvName)
f_cells_t = csvread(csvName);
f_t = f_cells_t(i,:); % get f(t) or the "i"th cell

[f_o,delta_f,delta_f_Mov] = deltaFCalc(f_t);
%Define file names
filename = strcat(int2str(i),'cell_f.tif')
filename_Mov = strcat(int2str(i), 'cell_f_Mov.tif')
dirfname = strcat('dir_plots/',filename)
dirfname_Mov = strcat('dir_plots/',filename_Mov)

plot(delta_f/f_o)
saveas(gcf,dirfname)
plot(delta_f_Mov/f_o)
saveas(gcf, dirfname_Mov)

end

function [f_o,delta_f,delta_f_Mov] = deltaFCalc(f_t)
%Calculate delta_f wrt first frame
f_o = f_t(1);
delta_f = f_t(:)-f_o;

%Calculate delta_f wrt moving average 10 frames
movAvg_f = movmean(f_t(:),10);
delta_f_Mov = f_t(:) - movAvg_f;
end

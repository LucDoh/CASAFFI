% STEP 4: COMPUTING Delta(F)/F and PLOTTING
% Taking in a csv of the bgd subtracted fluorescences for each cell,
% compute Delta(F)/Fs and write to csv dFF_csvname. m is the number of
% frames for moving average/median.
function dFF_csvName = plot_dFF(csvName, m)
    f_cells_t = csvread(csvName);
    dFF_Matrix = zeros(size(f_cells_t));
    for v = 1:size(f_cells_t,1)
        [~, movAvg_f, ~,delta_f_Mov]= deltaFCalc(f_cells_t(v,:), m);
        dFF_Matrix(v,:) = delta_f_Mov./movAvg_f;
    end
    dFF_csvName = strcat(erase(csvName,'_f_t_cells.csv'),'_DFF.csv');
    csvwrite(dFF_csvName,dFF_Matrix);
    %Pick cells to be plotted
    %cells = [12, 27, 48, 54, 5];
    cells = [1,2,3,4,5,6,7,8,9,10];
    figure
    for c=cells
        fPlot(c, csvName, m)
    end
    figure
end

function [] = fPlot(i, csvName, m)
f_cells_t = csvread(csvName);
f_t = f_cells_t(i,:);

%Compute Delta(F)/F 
[f_o, movAvg_f, delta_f,delta_f_Mov] = deltaFCalc(f_t, m);
%Define file names
filename = strcat(int2str(i),'cell_f.tif')
filename_Mov = strcat(int2str(i), 'cell_f_Mov.tif')
dirfname = strcat('dir_plots/',filename)
dirfname_Mov = strcat('dir_plots/',filename_Mov)

%plot(delta_f/f_o); saveas(gcf,dirfname)
figure
plot(delta_f_Mov./movAvg_f)
axis([0 length(movAvg_f) -0.5 0.5])
xlabel('Frames')
ylabel('\Delta F/F')
saveas(gcf, dirfname_Mov)
end

function [f_o, movAvg_f, delta_f,delta_f_Mov] = deltaFCalc(f_t, m)
%Calculate delta_f wrt first frame
f_o = f_t(1);
delta_f = f_t(:)-f_o;

%Calculate delta_f wrt moving median of 10 frames
movAvg_f = movmedian(f_t(:),m);
delta_f_Mov = f_t(:) - movAvg_f;

% Poss improvements:
%* Could try a moving window with lower percentile (Sylvester uses 10-25%)
%* Moving average should disclude spikes (anything above a zscore of 1.5)
end

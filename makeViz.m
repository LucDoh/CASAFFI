% STEP 7 (Final) - Video visualization using the centroids + spikes obtained.
% This was a WIP, but it does do in a basic way what it was made for.
function vid = makeViz(csvName_Centr, csv_Spikes)
    % Let's create a videowriter for a file called myVideo.avi
    writerObj = VideoWriter('myVideo.avi');
    writerObj.FrameRate = 30;
    % Open and write frames
    open(writerObj);
    centroids = csvread(csvName_Centr);
    spikeMatrix = csvread(csv_Spikes);
    numFrames = size(spikeMatrix,2);
    set(0,'DefaultFigureVisible','off'); %Force figures to NOT display
    for i = 1:100
        gcf_i = makeFrameImg(centroids, spikeMatrix, i);
        F = getframe(gcf_i);
        [X,map] = frame2im(F);
        writeVideo(writerObj,im2frame(X,map))
    end
    close(writerObj)

end


function gcf_i = makeFrameImg(centroids, spikeMatrix, i)
    %Start with blank figure, iterate thru cells and
    gcf_i = figure;
    plot(centroids(:,1),centroids(:,2), 'k.')
    hold on
    for j = 1:size(spikeMatrix,1)

        if(spikeMatrix(j,i) == 1)
            %Add dot to image if firing.
            plot(centroids(j,1),centroids(j,2),'ro')
        end
    end
    hold off
end

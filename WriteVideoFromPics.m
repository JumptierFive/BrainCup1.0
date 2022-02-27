%% writing videos
clc;close all;clear all;
writerObj=VideoWriter('VideoTractNEW.avi');
open(writerObj);
F.colormap=[];
Figs=filename_list('videoPicsNEW/','*png');
for i=1:1:length(Figs)
    clc
    i
    I=imread(Figs{i});
    F.cdata=I;
    writeVideo(writerObj,F);
end
close(writerObj);

%For combining and plotting of traces output from Fiji ShollAnalysis
%program
%Run this script on a folder that contains .CSV files from one condition

%Calls CheckFiles and MedianRadii
%Output: plot of data and a list of median sholl radii- called
%medians_list, list of medians (Medians) at each radius (Radplot) and
%associated standard deviations (Standdev)

files = dir('*.csv');
numfls = numel(files);

radii = []; %stores radii of interesection (from explant)
inters = []; %stores non-normalized intersections
inters_norm = []; %stores intersections normalized to max number per explant

%need to check for gaps and fix arrays accordingly. 

for i = 1:numfls; 
    Temp = importdata(files(i).name);
    display(files(i).name)
    [rad,int] = CheckFiles(Temp);
    radii = nancat(2,radii,rad);
    inters_norm = nancat(2,inters_norm,int./nanmax(int));
    inters = nancat(2,inters,int);
end


Medians = nanmedian(inters_norm');
Medians = Medians';

Standdev = nanstd(inters_norm');
Standdev = Standdev';
    

maxrad = max(max(radii));
Radplot = 0:5:maxrad; Radplot = Radplot';
hold on
% plot(Radplot,Medians)
errorbar(Radplot,Medians,Standdev);

MedianRadii

clearvars -except Radplot Medians Standdev medians_list
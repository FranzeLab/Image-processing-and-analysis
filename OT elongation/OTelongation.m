% ---------------------------------------------------------
% Analyze of Axon Bundles.
% Written by Matheus P. Viana, 07.28.2013
% vianamp@gmail.com

% ---------------------------------------------------------

% PICTURES NEED WHITE MARGIN!!!

% Setting workspace:
% ------------------
clear all; close all; clc; colormap('gray');

% Rewrite for windows by David Koser 23.10.2014
% IF CODE DOESN'T WORK; SEE COMMENT IN LINE 104!
%% determine files to open
[FileName,PathName,FilterIndex] = uigetfile('*.tif','Resultsfiles',...
    'MultiSelect','on');
dataset.name=PathName;

q = iscell(FileName);
if (q == 0)
    FileName = {FileName};
end

[w,NumberOfFiles] =  size(FileName);

% loop over all files
filelist = [];
for i = 1:NumberOfFiles
    filename = [PathName FileName{i}];
    dataset.files{i} = filename;
end


% For each TIFF file in the folder

for f = 1 : length(dataset.files)
    
% % %     remain_text = dataset.files{f};
% % %     while (length(remain_text)>0)
% % %         [filename,remain_text] = strtok(remain_text,'/')
% % %     end

    % Extracting outline
    
    im = imread(dataset.files{f});
    
    figure(1)
    imshow(im, []);

    if min(min(im,[],2))~=min(min(im,[],1))
        'ERROR'
        break
    end
    min(min(im,[],1))
    im = 255-255*(im==min(min(im,[],1)));
    im = bwlabel(im,4);
    
    
% % %     for i=1:max(max(im))
% % %         figure(1+i)
% % %         imshow((im==i) * 255, []);
% % %     end
% % %     break
% %     figure(2)
% %     imshow((im==2)*255, []);

% if pics don't work, try changing 2 in next line to 1 (or vice versa)!!!
    im = (im==1) * 255;
    im = abs(im-255);
% %     IMsize = size(im);
    im = im(3:end-2,3:end-2);
    sy = size(im,1);
    
    figure(2)
    imshow(im, []);
% % % % %     break
% % % end
% % % break
% % % for f = 1 : length(dataset.files)
    % Properties of the ROI
    
    dataset.m.area = length(find(im==255));
    majax = regionprops(im==255,'MajorAxisLength');
    minax = regionprops(im==255,'MinorAxisLength');
% %     majax.MajorAxisLength
% %     minax.MinorAxisLength
    dataset.m.elongation = majax.MajorAxisLength/minax.MinorAxisLength;

    [B,~] = bwboundaries(im,'noholes');

    % Showing outline
    figure(3)
    clf; hold all;
    
    plot(B{1}(:,2),sy-B{1}(:,1),'LineWidth',1,'Color',[0.5,0.5,0.5]);
    dataset.m.perimeter = sum(sqrt( diff(B{1}(:,1)).^2 + diff(B{1}(:,2)).^2 ));
    xmin = min(B{1}(:,2)); xmax = max(B{1}(:,2));
    ymin = min(sy-B{1}(:,1)); ymax = max(sy-B{1}(:,1));
    delta_max = max([xmax-xmin ymax-ymin]);
    xlim([xmin-5 xmin+delta_max+5]);
    ylim([ymin-5 ymin+delta_max+5]);

    % Skeletonization

    im = bwmorph(im,'skel',Inf);
    im = bwmorph(im,'spur');
    im = bwmorph(im,'skel',Inf);
    im = bwmorph(im,'spur');
    im = bwmorph(im,'skel',Inf);
    im = bwmorph(im,'spur');
    im = bwmorph(im,'skel',Inf);
    
    imb = bwmorph(im,'branchpoints');
    [yb,xb] = find(imb>0);

    ime = bwmorph(im,'endpoints');
    [ye,xe] = find(ime>0);
       
    % Skeleton properties

    dataset.m.nbranches = bwarea(imb);
    dataset.m.nendpoints = bwarea(ime);
    dataset.net.coor = [[xe;xb],[ye;yb]];
    dataset.net.n = length(dataset.net.coor);
    
    im = -im;
    for i = 1 : dataset.net.n
        im(dataset.net.coor(i,2),dataset.net.coor(i,1)) = i;
    end
       
    skell = trackskeleton(dataset.net.coor,im);

    for p = 1 : length(skell.paths)
        plot(skell.paths{p}(:,1),sy-skell.paths{p}(:,2),'LineWidth',2);
        skell.length(p) = sum(sqrt((diff(skell.paths{p}(:,1)).^2+diff(skell.paths{p}(:,2)).^2)));
    end
    plot(xb,sy-yb,'o','MarkerSize',10,'MarkerFaceColor','Red','MarkerEdgeColor','Black');
    plot(xe,sy-ye,'o','MarkerSize',10,'MarkerFaceColor','Green','MarkerEdgeColor','Black');
    for i = 1 : length(dataset.net.coor)
        text(dataset.net.coor(i,1)+10,sy-dataset.net.coor(i,2),['\bf ' num2str(i)],'FontSize',10,'Color','Black');
    end

    dataset.m.complexity = sum(skell.length(:)) / dataset.m.nbranches;
    
    % Saving results
    
	fid = fopen([dataset.files{f}(1:end-4) '_result.txt'],'wt');

    fprintf(fid, 'Cell statistics\n\n');
    fprintf(fid, 'Area (pixels): %s\n',num2str(dataset.m.area));
    fprintf(fid, 'Perimeter (pixels): %f\n',dataset.m.perimeter);
    fprintf(fid, 'Elongation: %f\n',dataset.m.elongation);
    fprintf(fid, 'Number of branches: %d\n',dataset.m.nbranches);
    fprintf(fid, 'Number of end points: %d\n',dataset.m.nendpoints);
    fprintf(fid, 'Complexity: %f\n',dataset.m.complexity);
    fprintf(fid, '\nAxons length (pixels)\n\n');
    for e = 1 : length(skell.paths)
        fprintf(fid,'%d \t %d \t %f\n',skell.list(e,1),skell.list(e,2),skell.length(e));
    end
    fclose(fid);

    % Saving PDF
    
    print(gcf,'-dpdf','-r300',[dataset.files{f}(1:end-4) '_diagram.pdf']);
    
end
 
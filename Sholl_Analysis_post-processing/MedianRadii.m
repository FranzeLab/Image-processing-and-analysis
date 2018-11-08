histdata = [];
medians_list = [];
for a = 1:numfls
    t = inters(:,a);
    t(isnan(t)) = 0;
    histdata = [];
    for b = 1:length(Radplot);
        tt = (ones(t(b),1).*Radplot(b));
        histdata = nancat(1,histdata,tt);

    end
median = nanmedian(histdata);
medians_list = cat(1,medians_list,median)
end

        
        
    
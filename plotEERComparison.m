function plotEERComparison( yIntersect, tols);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

xlbl = 'Distance';
leg = {'1G','2G','3G','4G','5G'};

[maxCompNum, numOfTols] = size(yIntersect);

syms = {'-cp','-mo','-.rs',':g','-bx','-y+','-mp'};

for i=1:maxCompNum
    plot(tols, yIntersect(i,:),syms{i},'LineWidth',3,'MarkerSize',5);
    hold on
end
set(gca,'FontSize',14)
l = legend(leg);
set(l,'FontSize',14);
xlabel(xlbl, 'FontSize',20) % x-axis label
ylabel('EER %', 'FontSize',20) % y-axis label

hold off

end


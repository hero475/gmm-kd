function [xIntersect, yIntersect] = plotErrorValues(FARValues, FRRValues, thresholds);

[maxCompNum, numOfTols] = size(FARValues);
CM = jet(90);
syms = ['-',':','--',':'];

xIntersect = zeros(maxCompNum,numOfTols);
yIntersect = zeros(maxCompNum,numOfTols);
for i=1:maxCompNum
    for j=1:numOfTols
        
        far = FARValues{i,j};
        frr = FRRValues{i,j};
        [xout,yout] = intersections(thresholds,far,thresholds,frr,1);
if(numel(xout)==0)
    yout = min(far);
    xout = min(frr);
end
        xIntersect(i,j) = xout(1);
        yIntersect(i,j) = yout(1);
    end
end

end
    
function [normExperiments] = normalizeExperiments(experiments)
% normalize each compareMatrix row-wise for every mixture model in the
% experiments that we have statistics for
[maxCompNum,numOfTols] = size(experiments);
normExperiments = experiments;

for i=1:maxCompNum
    for j=1:numOfTols
        nEx = normExperiments{i,j};
        nEx.compareMatrix = bsxfun(@rdivide,nEx.compareMatrix,max(nEx.compareMatrix,[],2));
        %nEx.compareMatrix = bsxfun(@rdivide,nEx.compareMatrix,digraphCount);
        normExperiments{i,j} = nEx;
    end
end

end
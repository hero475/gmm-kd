function [mu, sigma, weight, logl, N] = digraphSimple( userId, digraphStr, gaussNum, latency)

% it loads the timing info file or read it from the specified path below (if it is
% empty) for a particular user (userId) and his digraph records (digraphStr)
% the function decomposes the timing data into mixture models


mu = 0; sigma = 0; weight = 0; logl = -9999999; N = 0;
numIter = 200;

if(nargin<4)
    filePath = ['trainset/'...
        userId,'_digraph_',digraphStr,'.txt'];
    
    %check if the file exists
    if(exist(filePath,'file')==0)
        disp('invalid filepath for digraph data');
        return
    end
    latency = importdata(filePath);
end



if(gaussNum>0)
    [mu, sigma, weight, logl, N] = finiteGMMFinder(latency, gaussNum, numIter);
end


end


% decompose a dataset into GMMs
function [mu, sigma, weight, logl, N] = finiteGMMFinder(latency, gaussNum, numIter)
options = statset('Display','off','MaxIter',numIter);
GMModel = fitgmdist(latency,gaussNum,'Options',options,'CovType','diagonal',...
    'Replicates',1, 'Regularize',.1);
N = GMModel.NComponents;
logl = -GMModel.NlogL;
% separating N Gaussians
mu = zeros(N,1);
sigma = zeros(N,1);
weight = zeros(N,1);
for n = 1:N,
    mu(n)          = GMModel.mu(n);
    sigma(n)       = sqrt(GMModel.Sigma(1,1,n));
    weight(n)      = GMModel.PComponents(n);
end
end
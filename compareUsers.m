function [experiments, tols] = compareUsers(statsAll, users, testData);

% compares all users with each other
% maxCompNum    the maximum number of components of the fromUsers'
% statistics to be involved in the comparison. In other words, up to what
% components of statsAll (statsAll{1,1}.stats{1,1}, statsAll{1,1}.stats{2,1},...
% for the first digraph) is desired to be involved.
%   The statistics from statsAll is retrieved for users whose train
%   data is used to find the statistics of the mixture model (mean,
%   standard deviation, weight vectors, etc.). All users' test data is
%   read and compared with others to calculate how likely each user
%   might have generated the user's statistics. The score
%   function uses the Gaussian distance (tol*sigma) measurment and adds up
%   each time the user's pass rate is above a certain threshold.

maxCompNum = 5;

tols = [0.1 0.25 0.5 0.6 0.7 0.75 0.8 0.9 1 1.1 1.2 1.25 1.3 1.4 1.5 1.75 2.0];
numOfUsers = numel(users);

numOfTols = numel(tols);
experiments = cell(maxCompNum,numOfTols);


%chars = char(97:122); % Or just use: s = 'abcdefghijklmnopqrstuvwxyz';
chars1 = 'abcdefghijklmnopqrstuvwxyz';
chars2 = 'abcdefghijklmnopqrstuvwxyz';
for ns = 1:length(chars1)
    for ns2 = 1:length(chars2)
        digraphStr = [chars1(ns),chars2(ns2)];
        
        stats = statsAll{ns,ns2}.stats;
        d = statsAll{ns,ns2}.digraph;
        if (~strcmp(d,digraphStr))
            error('DIGRAPHS DO NOT MATCH!!!');
        end
        %disp(['digraph: ' digraphStr]);
        for ui=1:numOfUsers
            userId = users{ui};
            
            if(nargin<2)
                filePath = ['test_Digraph/',...
                    userId,'_digraph_',digraphStr,'.txt'];
                
                %check if the file exists
                if(exist(filePath,'file')==0)
                    continue;
                end
                testLatency = importdata(filePath);
            else
                testLatency = testData{ui}{ns}{ns2};
                
            end
            numOfRecords = numel(testLatency);
            
            if (numOfRecords>10)
                
                for compNum=1:maxCompNum
                    for tolId=1:numOfTols
                        tol = tols(tolId);
                        compareMatrix = zeros(numOfUsers,numOfUsers);
                        %compareMatrixFail = zeros(numOfToUsers,numOfFromUsers);
                        
                        for usr=1:numOfUsers
                            s = stats{compNum,usr};
                            if (isempty(s)) continue;   end
                            mu = s.mu;
                            sigma = s.sigma;
                            numOfPass = zeros(1,numel(mu));
                            %numOfFail = zeros(1,numel(mu));
                            
                            for i=1:numOfRecords
                                for j=1:numel(mu)
                                    if(testLatency(i) >= mu(j)-tol*sigma(j) && testLatency(i) <= mu(j)+tol*sigma(j))
                                        numOfPass(j) = numOfPass(j) + 1;
                                    %else    numOfFail(j) = numOfFail(j) + 1;
                                    end
                                end
                            end
                            
                            w = s.weight;
                            if (size(w,2)~=1) w = w'; end
                            weightedPass = sum(numOfPass*w);
                            %weightedFail = sum(numOfFail*s.weight);
                            %weightedPass = sum(numOfPass);
                            %passRate = weightedPass/numOfRecords;
                            passRate = weightedPass;
                            compareMatrix(ui,usr) = passRate;
                            %compareMatrixFail(ui,usr) = weightedFail;
                        end
                        
                        ex = experiments{compNum,tolId};
                        if (numel(ex)==0)
                            ex = struct('components', compNum, 'tolerance', tol, 'compareMatrix', compareMatrix);%, 'compareMatrixFail', compareMatrixFail);
                        else
                            ex.compareMatrix = ex.compareMatrix + compareMatrix;
                            %ex.compareMatrixFail = ex.compareMatrixFail + compareMatrixFail;
                        end
                        
                        experiments{compNum,tolId} = ex;
                    end
                end
                
            end
        end
        
        
    end
end




end
function [FRRValues, FARValues, thresholds] = calcErrorRates(experiments);

[maxCompNum, numOfTols] = size(experiments);
[normExperiments] = normalizeExperiments(experiments);

FRRValues = cell(maxCompNum,numOfTols);
FARValues = cell(maxCompNum,numOfTols);
thresholds = [0.1:0.001:1];
%thresholds = [0.95];
numOfThresh = numel(thresholds);
    
    
    for compNum=1:maxCompNum
        for tolNum=1:numOfTols
            %disp(['component: ' num2str(compNum) ' with treshold: ' num2str(tolNum)]);
            FRRVal = zeros(1,numOfThresh);
            FARVal = zeros(1,numOfThresh);
            for i=1:numOfThresh
                threshold = thresholds(i);
                ex = normExperiments{compNum, tolNum};
                compareMatrix = ex.compareMatrix;
                FRR = calcFRR(compareMatrix, threshold);
                FAR = calcFAR(compareMatrix, threshold);
                FRRVal(1,i) = FRR;
                FARVal(1,i) = FAR;
            end
            
            FRRValues{compNum,tolNum} = FRRVal*100;
            FARValues{compNum,tolNum} = FARVal*100;
        end
    end    
    
end

function [FAR] = calcFAR(compareMatrix, threshold)
numOfUsers = size(compareMatrix,1);
compareMatrix(1:numOfUsers+1:end) = -1;
numOfFA = numel(find(compareMatrix>threshold));
FAR = numOfFA/(numOfUsers*numOfUsers);

end



function [FRR] = calcFRR(compareMatrix, threshold)

numOfUsers = size(compareMatrix,1);
numOfReject = numel(find(diag(compareMatrix)<threshold));
FRR = numOfReject/numOfUsers;

end
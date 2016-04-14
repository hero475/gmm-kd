function [digraphCount] = countNumOfDigraph(users)

numOfUsers = numel(users);
digraphCount = zeros(1,numOfUsers);

for ui=1:numOfUsers
    
    chars1 = 'abcdefghijklmnopqrstuvwxyz';
    chars2 = 'abcdefghijklmnopqrstuvwxyz';
    for ns = 1:length(chars1)
        for ns2 = 1:length(chars2)
            digraphStr = [chars1(ns),chars2(ns2)];
            userId = users{ui};
            filePath = strjoin({'./testset/',...
                userId,'_digraph_',digraphStr,'.txt'}, '');
            %check if the file exists
            if(exist(filePath,'file')==0)
                continue;
            end
            testLatency = importdata(filePath);
            numOfRecords = numel(testLatency);
            
            if (numOfRecords>10)
                digraphCount(ui) = digraphCount(ui)+numOfRecords;
            end
        end
    end
end

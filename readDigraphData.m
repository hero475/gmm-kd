function [trainData, testData, users] = readDigraphData();
% read all digraph records of users separated as train/test data at the
% specified path. This function is used to store the data in memory so that
% each time a digraph is processed, we don't need to maki file I/O
% operation which degrades the performance

users = {'34','81'};
chars = 'abcdefghijklmnopqrstuvwxyz';
trainData = cell(0);
testData = cell(0);
minNumOfRecords = 10;
ltLimit = 100;

for ns = 1:length(chars)
    for ns2 = 1:length(chars)
        digraphStr = [chars(ns),chars(ns2)];
        for ui=1:numel(users)
            userId = users{ui};
            trainData{ui}{ns}{ns2} = [];
            testData{ui}{ns}{ns2} = [];
            
            %% import train data
            filePath = ['./trainset/',userId,'_digraph_',digraphStr,'.txt'];
            
            %check if the file exists
            if(exist(filePath,'file')==0)
                %disp(['The file does not exist: ' filePath]);
                continue;
            end
            latency = importdata(filePath);
            latency = latency( latency < ltLimit );
            numOfRecords = numel(latency);
            %% 80% is train data
            if(numOfRecords<minNumOfRecords*0.8)
                continue;
            end
            trainData{ui}{ns}{ns2} = latency;
            
            %% import test data
            filePath = ['./testset/',userId,'_digraph_',digraphStr, '.txt'];
            
            %check if the file exists
            if(exist(filePath,'file')==0)
                continue;
            end
            latency = importdata(filePath);
            latency = latency( latency < ltLimit );
            numOfRecords = numel(latency);
            %% 20% is test data
            if(numOfRecords<minNumOfRecords*0.2)
                continue;
            end
            testData{ui}{ns}{ns2} = latency;
        end
    end
end

end
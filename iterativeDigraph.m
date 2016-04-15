function [statsAll] = iterativeDigraph(users,trainData);
% generates digraph statistics of users' GMMs. All GMMs are being generated
% up to 5G (GMM with 5 components) for each user in users using the data
% in trainData for all possible digraps.

numOfUsers = numel(users);
maxCompNum = 5;
chars1 = 'abcdefghijklmnopqrstuvwxyz';
chars2 = 'abcdefghijklmnopqrstuvwxyz';
statsAll = cell(length(chars1),length(chars2));


for ns = 1:length(chars1)
    for ns2 = 1:length(chars2)
        digraphStr = [chars1(ns),chars2(ns2)];
        stats = cell(maxCompNum,numOfUsers);
        disp(['Processing ' digraphStr]);
        for comp=1:maxCompNum
            for ui=1:numOfUsers
                userId = users{ui};
                latency = trainData{ui}{ns}{ns2};
                if(numel(latency)>=10)
                    [mu, sigma, weight, logl, N] = digraphSimple( userId, digraphStr, comp, latency);
                    s = struct('id', userId, 'mu', mu, 'sigma', sigma, 'weight', weight, 'logl', logl, 'N', N);
                    stats{comp,ui} = s;
                end
            end
        end
        sAll = struct('digraph', digraphStr, 'stats', struct());
        sAll.stats = stats;
        statsAll{ns,ns2} = sAll;    
    end
end
end


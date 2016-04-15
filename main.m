[trainData, testData, users] = readDigraphData();
[statsAll] = iterativeDigraph(users,trainData);
[experiments, tols] = compareUsers(statsAll, users, testData);
[FRRValues, FARValues, thresholds] = calcErrorRates(experiments);
[xIntersect, yIntersect] = plotErrorValues(FARValues, FRRValues, thresholds);
plotEERComparison( yIntersect, tols);
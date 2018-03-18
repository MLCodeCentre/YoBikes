function myHist(Data, BinRange)

figure;
Xcts = hist(Data, BinRange);
bar(BinRange, Xcts)
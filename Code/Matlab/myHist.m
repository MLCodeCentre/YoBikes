function myHist(Data, BinRange, x_label, Unit)

Xcts = hist(Data, BinRange);
bar(BinRange, Xcts)
%xlim([min(BinRange)-5, max(BinRange)+5])
ylabel('Frequency')
xlabel(strcat(x_label))

width = BinRange(2)-BinRange(1);
total = size(Data,1);

ylimits=get(gca,'ylim');
xlimits=get(gca,'xlim');
text(xlimits(2)*0.6, ylimits(2)*0.9, strcat(['Total: ', num2str(total)]))
text(xlimits(2)*0.6, ylimits(2)*0.85, strcat(['Bin width: ', num2str(width), ' ',  Unit]))
    
    
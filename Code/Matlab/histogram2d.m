function histogram2d(Data)

histogram2(Data.Duration, Data.Distance, 0:120, 0:0.1:3,'FaceColor','flat')
xlabel('Duration [Minutes]')
ylabel('Distance [km]')
colorbar

set(gca,'YScale','log')
set(gca,'XScale','log')

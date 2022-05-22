%%　生データ
raw=readmatrix("HOT2000_xlsx/task01.xlsx");
mark=raw(:,15);
I=find(mark==2);
fig1=figure('units','inch','position',[0,0,15,5]);
p1=plot(raw(I:end,2)-raw(I,2),raw(I:end,3)-raw(I,3),'LineWidth',2);
hold on;
p2=plot(raw(I:end,2)-raw(I,2),raw(I:end,4)-raw(I,4),'LineWidth',2);
hold on;
%% 課題時刻の表示
ylim tight
yl=ylim;
time=raw(I:end,2);
%音あり
mstrig =[300 2060 3820];
metrig=mstrig+580;

for i = 1:length(mstrig)
    plot(time(mstrig(i))*[1 1], yl, 'r:');
    plot(time(metrig(i))*[1 1], yl, 'r:');
end
%音なし
sstrig=[1180 2940 4700];
setrig=sstrig+580;
for i = 1:length(mstrig)
    plot(time(sstrig(i))*[1 1], yl, 'b:','LineWidth',1);
    plot(time(setrig(i))*[1 1], yl, 'b:','LineWidth',1);
end
hold on;
%% グラフの設定
xlim([0,raw(end,2)-raw(I,2)]);
xlabel('Time [s]');
ylabel('\DeltaHb [mM mm]');
set(gca,'Fontsize',17);
legend([p1,p2],{'left','right'} ...
    ,'Location','southwest','Fontsize',20);
%%　生データ
raw=readmatrix("HOT2000_xlsx/task02.xlsx");
mark=raw(:,15);
I=find(mark==2);

% fig1=figure('units','inch','position',[0,0,15,5]);
% ylim tight
% xlim tight
% plot(raw(I:end,2)-raw(I,2),raw(I:end,3)-raw(I,3));
% hold on
% plot(raw(I:end,2)-raw(I,2),raw(I:end,4)-raw(I,4));
% hold on; 
% time=raw(I:end,2)-raw(I,2);
% %音あり
% mstrig =[300 2060 3820];
% metrig=mstrig+580;
% sstrig=[1180 2940 4700];
% setrig=sstrig+580;
% yl=ylim;
% for i = 1:length(mstrig)
%     plot(time(mstrig(i))*[1 1], yl, 'r:');
%     plot(time(metrig(i))*[1 1], yl, 'r:');
% end
% 
% for i = 1:length(mstrig)
%     plot(time(sstrig(i))*[1 1], yl, 'b:','LineWidth',1);
%     plot(time(setrig(i))*[1 1], yl, 'b:','LineWidth',1);
% end
% hold off;
%% ドリフト除去
Fs=10;
 data1=raw(I:end,3)-raw(I,3);
 data2=raw(I:end,4)-raw(I,4);
 data=[data1 data2];
 b1 = fir1(500,0.01/(Fs/2),'high'); % 500次ハイパスフィルタ：遮断周波数 0.01 Hz
 hdata = filtfilt(b1, 1, data);
%  fig2=figure('units','inch','position',[0,0,15,5]);
%  plot(raw(I:end,2)-raw(I,2),hdata(:,1));
%  hold on
%  plot(raw(I:end,2)-raw(I,2),hdata(:,2));
%  ylim tight
%  xlim tight
% yl=ylim;
% for i = 1:length(mstrig)
%     plot(time(mstrig(i))*[1 1], yl, 'r:');
%     plot(time(metrig(i))*[1 1], yl, 'r:');
% end
% 
% for i = 1:length(mstrig)
%     plot(time(sstrig(i))*[1 1], yl, 'b:','LineWidth',1);
%     plot(time(setrig(i))*[1 1], yl, 'b:','LineWidth',1);
% end
%  hold off;
%% 平滑化
% fig3=figure('units','inch','position',[0,0,15,5]);
b2 = ones(1,10)/10; % 10点移動平均
lhdata = filtfilt(b2, 1, hdata);
% plot(raw(I:end,2)-raw(I,2),lhdata(:,1));
% hold on
% plot(raw(I:end,2)-raw(I,2),lhdata(:,2));
% ylim tight
% xlim tight
% yl=ylim;
% for i = 1:length(mstrig)
%     plot(time(mstrig(i))*[1 1], yl, 'r:');
%     plot(time(metrig(i))*[1 1], yl, 'r:');
% end
% 
% for i = 1:length(mstrig)
%     plot(time(sstrig(i))*[1 1], yl, 'b:','LineWidth',1);
%     plot(time(setrig(i))*[1 1], yl, 'b:','LineWidth',1);
% end
% 
% hold off;

%% 加算平均処理
bef1  = floor(30*Fs); 
aft1 = floor(58*Fs); 
tind2=[-1*bef1:aft1]/Fs; % 時刻インデックスの作成
tind3=[-1*bef1:aft1]/Fs;
ff1=301;
ff3=ff1+880;
sf1=ff3+880;
sf3=sf1+880;
tf1=sf3+880;
tf3=tf1+880;
mtriger=[ff1,sf1,tf1];
striger=[ff3,sf3,tf3];
avg1 = zeros(length(tind2), 2); 
avg2 = zeros(length(tind3), 2);
for n = 1:length(mtriger)
    avg1 = avg1 + lhdata(mtriger(n)-bef1:mtriger(n)+aft1,:);
end
for n = 1:length(striger)
    avg2 = avg2 + lhdata(striger(n)-bef1:striger(n)+aft1,:);
end
%disp(avg);
avg1 = avg1./3;
avg2 = avg2./3;
% ベースライン補正
avg1 = avg1 - repmat(avg1(bef1+1,:), length(avg1), 1);
avg2 = avg2 - repmat(avg2(bef1+1,:), length(avg2), 1);
% 加算平均波形の描画
 fig4=figure('units','inch','position',[0,0,15,5]);
%  subplot(2,2,1);
 plot(tind2, avg1(:,1), 'r');
 hold on;
 plot(tind2, avg1(:,2), 'b');
% hold on;
% xlim([-5,70]); yl = [-0.2, 0.2]; ylim(yl);
% plot([0,0], yl, 'k:'); plot([58,58], yl, 'k:');
%% 標準化
bef2=300;
sd1 = std(avg1(1:bef2,:));
navg1 = avg1./repmat(sd1,length(avg1), 1);
sd2 = std(avg2(1:bef2,:));
navg2 = avg2./repmat(sd1,length(avg2), 1);

fig5=figure('units','inch','position',[0,0,15,5]);
plot(tind2, navg1(:,1));
hold on;
plot(tind2, navg1(:,2));
hold on;
raw=readmatrix('HOT2000_xlsx/task05.xlsx');
%% HRFの概形
Fs=1/raw(2,3);
HRF=spm_hrf(0.1);
%% トリガ時刻の抽出
mark=raw(:,15);
I=find(mark==2);
tind = raw(I:end,2)-raw(I,2);
ff1=300;
mtrig =[300 2060 3820];
strig=[1180 2940 4700];

%% 課題に沿って活動する脳部位の活動モデル(ブロックデザイン)
data1 = raw(I:end,3)-raw(I,3);
data2 = raw(I:end,4)-raw(I,4);
data=[data1 data2];

mBlock = zeros(length(data), 1);
sBlock = zeros(length(data), 1);
task=580;
for i = 1:length(mtrig)
    mBlock(mtrig(i):mtrig(i)+task, 1) = 1;
    mBlock(mtrig(i):mtrig(i)+task, 1) = 1;
    mBlock(mtrig(i):mtrig(i)+task, 1) = 1;
end
for i = 1:length(strig)
    sBlock(strig(i):strig(i)+task, 1) = 1;
    sBlock(strig(i):strig(i)+task, 1) = 1;
    sBlock(strig(i):strig(i)+task, 1) = 1;
end

%% ブロックデザインとHRFの畳み込み積分
mconv = conv(mBlock, HRF);
sconv = conv(sBlock, HRF);

X1 = [mconv(1:length(data)), ones(length(data),1), [1:length(data)]'];
X2 = [sconv(1:length(data)), ones(length(data),1), [1:length(data)]'];

%% GLM

    %left
    [b1, bint1, r1, rint1, stats1] = regress(data(:,1), X1);
    [b2, bint2, r2, rint2, stats2] = regress(data(:,1), X2);

    disp(['lmBeta values = [',num2str(b1'),']']);
    disp(['lsBeta values = [',num2str(b2'),']']);

    [b3, bint3, r3, rint3, stats3] = regress(data(:,2), X1);
    [b4, bint4, r4, rint4, stats4] = regress(data(:,2), X2);

    disp(['rmBeta values = [',num2str(b3'),']']);
    disp(['rsBeta values = [',num2str(b4'),']']);
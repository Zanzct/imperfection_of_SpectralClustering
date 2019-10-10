
 data =  [4.8848    1.0673;
   -2.8681   -4.0956;
    0.6969    4.9512;
    4.9716    0.5319;
   -1.2985   -4.8284;
   -4.8493    1.2182;
    0.7024   -4.9504;
   -1.3674    4.8094;
   -1.5181   -4.7640;
    0.5733   -4.9670;
   -4.3832   -2.4058;
   -4.7152   -1.6634;
   -4.2404   -2.6494;
   -4.5369   -2.1015;
   -2.1619    4.5085;
   -4.8585   -1.1811;
    4.7854   -1.4491;
    3.8996    3.1294;
   -0.5561    4.9690;
   -2.9575    4.0315;
    9.7921   -2.0286;
   -8.4303    5.3786;
    8.8957   -4.5680;
   -4.4793   -8.9407;
   -9.1732   -3.9815;
   -8.8980    4.5634;
    8.2141   -5.7034;
    5.5402   -8.3250;
   -9.7634    2.1626;
    2.4367   -9.6986;
   -3.4128    9.3996;
    3.3661   -9.4164;
   -0.2576    9.9967;
    9.6692   -2.5507;
   -7.9397    6.0796;
   -5.7559   -8.1774;
   -1.4651   -9.8921;
    4.3449   -9.0068;
   -6.4241   -7.6636;
    9.9996   -0.0901;
   -9.8780   -1.5573;
    3.0273    9.5308;
    4.1979   -9.0762;
    7.2136    6.9256;
   -8.5106    5.2507;
    8.9359   -4.4888;
   -7.3309   -6.8013;
    9.3538   -3.5364;
   -9.9753    0.7018;
   -5.8005    8.1458]

%%谱聚类spectral clustering。1、构图用的是fully-connected,即邻接矩阵W与相似矩阵相同
%%2、切图。切图用的是N-cut。L=D^-0.5*L*D^-0.5。3、在用K-means对L的特征向量进行聚类，
%%注意分及各类用几个特征向量。
% clc;
% clear;
% load('data.mat')
% data = allpts
figure(1)
plot(data(:,1),data(:,2),'bo');
m = length(data);
%%
 
%% step1:构图，计算邻接矩阵W
sigsq = 0.9;   %高斯距离里面的方差
Aisq = data(:,1).^2 + data(:,2).^2
Dotprod = data*data'
distmat = repmat(Aisq,1,m) + repmat(Aisq',m,1) -2*Dotprod;   %此处画图理解
Afast = exp(-distmat/(2*sigsq));
W = Afast;
figure(2)
subplot(2,3,2);
imagesc(W);colorbar;
 
 
%% step2:计算拉普拉斯矩阵L
D = diag(sum(W));   %度矩阵degree matrix
L = D-W;   %拉普拉斯矩阵
L = D^-0.5*L*D^-0.5;   %标准化，切图我们用的是N-cut,所以要对拉普拉斯矩阵作标准化处理，使得量纲一致
subplot(2,3,3)
imagesc(L);colorbar;
 
 
%% step3:切图。
[X,di] = eig(L);
[Xsort,Dsort] = eigsorts(X,di);   %将特征值按照从小到大的顺序排列，特征向量跟随做相应变化。
Xuse = Xsort(:,1:2);   %取第一列与第二列，因为要分成k=2，即要分成两类。
subplot(2,3,4)
imagesc(Xuse);colorbar;
Xsq = Xuse.*Xuse;
divmat = repmat(sqrt(sum(Xsq')'),1,2);
Y = Xuse./divmat   %将Xuse标准化
subplot(2,3,5)
imagesc(Y);colorbar;
 
%% step4:用k-means均值聚类对Y进行聚类
[c,Dsum,z] = kmeans(Y,2);
c1 = find(c==1);
c2 = find(c==2);
subplot(2,3,6)
plot(data(c1,1),data(c1,2),'co')
hold on;
plot(data(c2,1),data(c2,2),'mo')
title('谱聚类');
 
 
%% 画出kmenas聚类对元数据聚类效果
[cc,Dsum2,z2] = kmeans(data,2);
subplot(2,3,1)
kk = cc;
c1 = find(cc==1);
c2 = find(cc==2);
plot(data(c1,1),data(c1,2),'bo')
hold on;
plot(data(c2,1),data(c2,2),'ro')
title('均值聚类');
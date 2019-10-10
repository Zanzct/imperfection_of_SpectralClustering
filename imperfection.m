clc;
clear;

data = [
    -3,1;
    -2,1;
    -1,1;
    0,1;
    1,1;
    2,1;
    3,1;
    4,1;
    -3,0;
    -2,0;
    -1,0;
    0,0;
    1,0;
    2,0;
    3,0;
    4,0;
    ];

%%谱聚类spectral clustering。1、构图用的是指定的无向图,邻接矩阵W与相似矩阵不同
%%2、切图。切图用的是N-cut。L=D^-0.5*L*D^-0.5。3、在用K-means对L的特征向量进行聚类，
%%注意分及各类用几个特征向量。

% figure(1)
% plot(data(:,1),data(:,2),'bo');
figure(2)
subplot(2,3,1)
plot(data(:,1),data(:,2),'bo');
title('原始数据');
m = length(data);
%%
 
%% step1:构图，指定邻接矩阵W

W = [     
     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0
     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0
     0     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0
     0     0     1     1     1     0     0     0     0     0     0     0     0     0     0     0
     0     0     0     1     1     1     0     0     0     0     0     0     1     0     0     0
     0     0     0     0     1     1     1     0     0     0     0     0     0     1     0     0
     0     0     0     0     0     1     1     1     0     0     0     0     0     0     1     0
     0     0     0     0     0     0     1     1     0     0     0     0     0     0     0     1
     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     0
     0     0     0     0     0     0     0     0     1     1     1     0     0     0     0     0
     0     0     0     0     0     0     0     0     0     1     1     1     0     0     0     0
     0     0     0     0     0     0     0     0     0     0     1     1     1     0     0     0
     0     0     0     0     1     0     0     0     0     0     0     1     1     1     0     0
     0     0     0     0     0     1     0     0     0     0     0     0     1     1     1     0
     0     0     0     0     0     0     1     0     0     0     0     0     0     1     1     1
     0     0     0     0     0     0     0     1     0     0     0     0     0     0     1     1
    ];
subplot(2,3,2);
imagesc(W);colorbar;
 
 
%% step2:计算拉普拉斯矩阵L
D = diag(sum(W));   %度矩阵degree matrix
L = D-W;   %拉普拉斯矩阵
L = D^-0.5*L*D^-0.5;   %标准化，切图我们用的是N-cut,所以要对拉普拉斯矩阵作标准化处理，使得量纲一致
subplot(2,3,3)
imagesc(L);colorbar;
 
 
%% step3:切图。
k = 2    %分为k类
[X,di] = eig(L);
[Xsort,Dsort] = eigsorts(X,di);   %将特征值按照从小到大的顺序排列，特征向量跟随做相应变化。
Xuse = Xsort(:,1:k);   %取第一列与第二列，因为要分成k=2，即要分成两类。
subplot(2,3,4)
imagesc(Xuse);colorbar;
Xsq = Xuse.*Xuse;
divmat = repmat(sqrt(sum(Xsq')'),1,k);
Y = Xuse./divmat   %将Xuse标准化
subplot(2,3,5)
imagesc(Y);colorbar;
 
%% step4:用k-means均值聚类对Y进行聚类
[c,Dsum,z] = kmeans(Y,k);
c1 = find(c==1);
c2 = find(c==2);
% c3 = find(c==3);
subplot(2,3,6)
plot(data(c1,1),data(c1,2),'bo')
hold on;
plot(data(c2,1),data(c2,2),'b*')
% hold on;
% plot(data(c3,1),data(c3,2),'r*')
title('谱聚类');
 
 
%% 画出kmenas聚类对元数据聚类效果
% [cc,Dsum2,z2] = kmeans(data,k);
% subplot(2,3,1)
% kk = cc;
% c1 = find(cc==1);
% c2 = find(cc==2);
% c3 = find(cc==3);
% plot(data(c1,1),data(c1,2),'ro')
% hold on;
% plot(data(c2,1),data(c2,2),'b*')
% hold on;
% plot(data(c3,1),data(c3,2),'r*')
% title('均值聚类');

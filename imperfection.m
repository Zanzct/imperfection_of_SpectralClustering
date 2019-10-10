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

%%�׾���spectral clustering��1����ͼ�õ���ָ��������ͼ,�ڽӾ���W�����ƾ���ͬ
%%2����ͼ����ͼ�õ���N-cut��L=D^-0.5*L*D^-0.5��3������K-means��L�������������о��࣬
%%ע��ּ������ü�������������

% figure(1)
% plot(data(:,1),data(:,2),'bo');
figure(2)
subplot(2,3,1)
plot(data(:,1),data(:,2),'bo');
title('ԭʼ����');
m = length(data);
%%
 
%% step1:��ͼ��ָ���ڽӾ���W

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
 
 
%% step2:����������˹����L
D = diag(sum(W));   %�Ⱦ���degree matrix
L = D-W;   %������˹����
L = D^-0.5*L*D^-0.5;   %��׼������ͼ�����õ���N-cut,����Ҫ��������˹��������׼������ʹ������һ��
subplot(2,3,3)
imagesc(L);colorbar;
 
 
%% step3:��ͼ��
k = 2    %��Ϊk��
[X,di] = eig(L);
[Xsort,Dsort] = eigsorts(X,di);   %������ֵ���մ�С�����˳�����У�����������������Ӧ�仯��
Xuse = Xsort(:,1:k);   %ȡ��һ����ڶ��У���ΪҪ�ֳ�k=2����Ҫ�ֳ����ࡣ
subplot(2,3,4)
imagesc(Xuse);colorbar;
Xsq = Xuse.*Xuse;
divmat = repmat(sqrt(sum(Xsq')'),1,k);
Y = Xuse./divmat   %��Xuse��׼��
subplot(2,3,5)
imagesc(Y);colorbar;
 
%% step4:��k-means��ֵ�����Y���о���
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
title('�׾���');
 
 
%% ����kmenas�����Ԫ���ݾ���Ч��
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
% title('��ֵ����');

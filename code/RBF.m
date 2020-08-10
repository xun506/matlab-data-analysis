function ErrorList2 = RBF(data,Fig2_1,Fig2_2,Fig2_3,Fig2_4)

%训练正常波形
y = data;%读取波形
x = 1:length(y);

n1 =zeros(20,length(y)/2-20);%设置输入向量
for n=1:length(y)/2-20
    column=zeros(1,20);
    for i=1:20
        column(i)=y(n+i);
    end
    n1(:,n)=column;
end
x1 = zeros(1,length(y)/2-20);%设置输出向量
for n=1:length(y)/2-20
    x1(n)=y(n+20);
end
xn_train = n1; % 训练样本
dn_train = x1; % 训练目标
P = xn_train;
T = dn_train;
goal = 0.05; % 训练误差的平方和(默认为0)
spread = 10; % 此值越大,需要的神经元就越少(默认为1)
MN = size(xn_train,2); % 最大神经元数(默认为训练样本个数)
DF = 1; % 显示间隔(默认为25)

normalnet = newrb(P,T,goal,spread,MN,DF);
%测试
%拟合后的神经网络预测整个波形
% figure(1)

axes(Fig2_2);cla reset;
ytest1=data;
ytest_p=zeros(20,length(y)-20);%测试预测能力
for n=1:length(y)-20
    column=zeros(1,20);
    for i=1:20
        column(i)=y(n+i);
    end
    ytest_p(:,n)=column;
end
yout=zeros(1,length(y));
% 前20个点默认与实际波形相同，从第21个点开始预测
for i=1:20
    yout(i)=ytest1(i);
end
for i=21:length(yout)
    yout(i)=sim(normalnet,ytest_p(:,i-20));
end
t=[0:0.2/length(yout):0.2-0.2/length(yout)];
plot(t,yout);
hold on;
n=[0:0.2/length(yout):(length(ytest1)-1)*0.2/length(yout)];
plot(n,ytest1,'r');hold on;
legend('预测波形','实际波形')

axes(Fig2_3);cla reset;
dif = yout'-ytest1;
plot(n,yout'-ytest1,'b');
title('预测差值');

axes(Fig2_4);cla reset;
normplot(dif);%若X为向量，则显示正态分布概率图形，若X为矩阵，则显示每一列的正态分布概率图。
              %如果数据来自正态分布，则图形显示为直线，而其它分布可能在图中产生弯曲。
[muhat,sigmahat,muci,sigmaci] = normfit(dif,0.90);%muhat,sigmahat分别为正态分布的参数μ和σ的估计值；,muci,sigmaci分别为置信区,其置信度为：0.95
%disp(pd);
section = sigmahat*2;       %应该是3σ准则，这里为效果，用2σ

axes(Fig2_1);cla reset;
plot(x,y);
hold on;
ErrorList2=[];
for i=1:length(x)
    if abs(dif(i))>=section
        plot(i,y(i),'x','Color',[1 0 0]);hold on;
        ErrorList2 = [ErrorList2 i];
    end
end
title('原始数据异常值标记点图');
grid on;

end
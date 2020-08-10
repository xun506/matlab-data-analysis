function ErrorList2 = Holt_Winters(data,alpha,Fig2_1,Fig2_2,Fig2_3,Fig2_4)
% Holt-Winter指数平滑法 
% Designed by ShengjieZhu
% Modified by xufei on 2020/6/2

[m,~]=size(data);
x=0:1:m-1;
y=data(:,1);

axes(Fig2_1);
cla reset;
plot(x,y);
title('原始数据统计图');
grid on;

yAct=data;n=length(yAct);
sub=0;
% alpha=0.3;
sub=sub+1;
st1_0=mean(yAct(1:3)); st2_0=st1_0;st3_0=st1_0; 
st1(1)=alpha*yAct(1)+(1-alpha)*st1_0; 
st2(1)=alpha*st1(1)+(1-alpha)*st2_0; 
st3(1)=alpha*st2(1)+(1-alpha)*st3_0; 
for i=2:n
    st1(i)=alpha*yAct(i)+(1-alpha)*st1(i-1);    
    st2(i)=alpha*st1(i)+(1-alpha)*st2(i-1); 
    st3(i)=alpha*st2(i)+(1-alpha)*st3(i-1);
end
a=3*st1-3*st2+st3; 
b=0.5*alpha/(1-alpha)^2*((6-5*alpha)*st1-2*(5-4*alpha)*st2+(4-3*alpha)*st3);
c=0.5*alpha^2/(1-alpha)^2*(st1-2*st2+st3); 
yFor=a+b+c;

axes(Fig2_2);cla reset;
plot(1:n,yAct,1:n,yFor(1:n));
title('预测数据与原始数据对比图');
grid on;
legend('Actual','Forecast');

var = 1/n*sum((yAct'-yFor(1:n)).^2);%方差
%disp(yhat)
for i=1:n
    dif(i) = yFor(1,i)-yAct(i,1);
end
% disp(dif)

axes(Fig2_3);cla reset;
histogram(dif,1000);
histfit(dif);
pd = fitdist(dif','Normal');
title('差值分布直方图');
grid on;

axes(Fig2_4);cla reset;
normplot(dif);%若X为向量，则显示正态分布概率图形，若X为矩阵，则显示每一列的正态分布概率图。
              %如果数据来自正态分布，则图形显示为直线，而其它分布可能在图中产生弯曲。
[muhat,sigmahat,muci,sigmaci] = normfit(dif,0.95);%muhat,sigmahat分别为正态分布的参数μ和σ的估计值；,muci,sigmaci分别为置信区,其置信度为：0.95
%disp(pd);
section = sigmahat*2;       %应该是3σ准则，这里为效果，用2σ

axes(Fig2_1);cla reset;
plot(x,y);
hold on;

ErrorList2=[];
for i=1:n
    if abs(dif(i))>=section
        plot(i-1,y(i),'x','Color',[1 0 0]);
        ErrorList2 = [ErrorList2 i];
    end
end

title('原始数据异常值标记点图');
grid on;



function ErrorList1 = setmonth_on_month(data,ts,t0,SubFig3)
% r(t) = [x(t) + x(t-1) + … + x(t-w+1)]/ [x(t-w) + x(t-w-1) + … + x(t-2w+1)]
%环比

axes(SubFig3);
cla reset;
w = 5;
L = length(data);
for i =2*w:L  %因为要与之前的均值比较，所以从2*w开始计算
    n(i)=mean(data(i-w+1:i))/mean(data(i-2*w+1:i-w));
end

if ts == 1
    n0 = autothresholdlow(n,t0);   %学习低阈值
    n1 = autothresholdhigh(n,t0);  %学习高阈值
else
    n0 = 0.98;   %固定低阈值
    n1 = 1.02;   %固定高阈值
end

ErrorList1=[];

for i =2*w:L
    if n(i)<n0 || n(i)>n1
         plot(i,n(i),'rx');
         hold on;
         ErrorList1 = [ErrorList1 i];
    end
end
p1 = plot(i,n(i),'rx');hold on;
p2 = plot([1 L],[n0 n0],'r--');hold on;
p3 = plot([1 L],[n1 n1],'k--');hold on;
p4 = plot(n);  
axis([1 L 0.9 1.02]); 
xlabel('采样时间');
ylabel('r空间');
legend([p1,p2,p3,p4],'异常点','Min阈值','Max阈值','Z曲线');
end
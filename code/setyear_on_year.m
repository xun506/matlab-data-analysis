function ErrorList1 = setyear_on_year(data,ts,t0,varargin)
% Z(t) = {x(t) – mean[x(t-kT-w):x(t-kT+w)]}/std(x(t-kT-w):x(t-kT+w))
%同比

hax = varargin{1};
global period               
k = 1;
w = 1;
g = period + w + 1;   %因为要与之前的均值和标准差比较，所以从period + w + 1开始计算
L = length(data);
for i = g:L
    n(i) =((data(i)-mean(data(i-k*period-w : i-k*period+w)))/std(data(i-k*period-w : i-k*period+w)));
end

if ts == 1
    n0 = autothresholdlow(n,t0);  %学习阈值
else
    n0 = -5;                      %固定阈值
end
ErrorList1=[];
axes(hax);
cla reset;

for i = g:L
    if n(i)<n0 
        p1 = plot(i,n(i),'rx','parent',hax);
        hold on;
        ErrorList1 = [ErrorList1 i];
        hold on
    end
end
p2 = plot([1 L],[n0 n0],'r--');hold on;
p3 = plot(n);hold on;
xlabel('采样时间');
ylabel('z空间');
legend([p1,p2,p3],'异常点','阈值','Z空间曲线');
end


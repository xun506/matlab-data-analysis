function ErrorList1 = setthreshold(data,ts,t0,SubFig2,SubFig3)

axes(SubFig3);cla reset;
n = smooth(data); %smooth平滑数据
p1 = plot(n);
hold on;


if ts == 1
    n0 = autothresholdlow(n,t0,SubFig2);%学习低阈值
    n1 = autothresholdhigh(n,t0,SubFig2);%学习高阈值
    
else
    n0 = 0;%固定低阈值
    n1 = 2;%固定高阈值
end

L = length(n);

% hax = varargin{2};
axes(SubFig3);
ErrorList1=[];
for i = 1:L
    if n(i)<n0 || n(i)>n1
        p2 = plot(i,n(i),'rx');
        hold on;
        ErrorList1 = [ErrorList1 i];
    end
end 
xlabel('采样时间');
ylabel('平滑后的数据');
legend([p1,p2],'平滑曲线','异常值');
end
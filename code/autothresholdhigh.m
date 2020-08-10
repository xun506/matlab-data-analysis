function n1 = autothresholdhigh(n,t0,SubFig2)
n = n.* -1;
[f,x] = ecdf(n);
x = x.* -1;
L = length(f);
i = 1;
while f(i) <= t0
    i = i + 1;
end
n1 = x(i-1);

switch nargin
    case 3
%       hax = varargin{1};
        axes(SubFig2);
        plot(x,f,'r');
        hold on
        plot([n1 n1],[0 1],'r--');
        legend('经验累积概率曲线','概率阈值','逆经验累积概率曲线','逆概率阈值');
        title('ECDF曲线');
        xlabel('平滑后数据值');
        ylabel('概率：%')
    otherwise
end
end
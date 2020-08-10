function n0 = autothresholdlow(n,t0,SubFig2)
% t0 = 0.1;
[f,x] = ecdf(n);

L = length(f);
i = 1;
while f(i) <= t0
    i = i + 1;
end
n0 = x(i-1);

switch nargin
    case 3
        axes(SubFig2);cla reset;
        plot(x,f);
        hold on
        plot([n0 n0],[0 1],'b--'); 
    otherwise
end
end
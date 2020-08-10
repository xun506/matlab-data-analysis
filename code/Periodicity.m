function ClassFlag = Periodicity(SourceData,SubFig2)

n0 = 0.1;                            % 峰值阈值
k = 5;                               %容忍度
n1 = 10;                             %判断周期阈值
L = length(SourceData);
T = 1/139;
t = (0:L-1)*T;                       % 时间
y = SourceData;
Fs = 1/T;
N = 2^nextpow2(L);                      %采样点数，采样点数越大，分辨的频率越精确，N>=L，超出的部分信号补为0
Y = fft(y,N)/N*2;                       %除以N乘以2才是真实幅值，N越大，幅值精度越高
f = Fs/N*(0:1:N-1);                     %频率
A = abs(Y);                             %幅值

axes(SubFig2);
cla reset;

p1 = plot(f(1:N/2),A(1:N/2),'parent',SubFig2);   %函数fft返回值的数据结构具有对称性,因此我们只取前一半
hold on

f1 = f(1:N/2);
[LOCS,PKS]=myfindpeaks(A(1:N/2),'',k,n0);
am1 = PKS;
pv1 = f1(LOCS);
p2 = plot(pv1,am1,'r*','parent',SubFig2); 
legend(SubFig2,[p1,p2,],'数据频谱','极大值');
[a,b] =max(am1);
global period
period = round(pv1(b));    %计算数据的周期

tmp = diff(pv1);
tmp = diff(tmp);

g = sum(abs(tmp));
if g < n1
    ClassFlag = 1;
    title(SubFig2,'分类是否为周期图形（是）');
else
    ClassFlag = 0;
    title(SubFig2,'分类是否为周期图形（否）');
end
    
end
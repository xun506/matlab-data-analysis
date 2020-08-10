function output = NARpredict(input,numnum)
%input为原始序列（行向量）

lag=3;    % 自回归阶数
n=length(input);

%准备输入和输出数据
inputs=zeros(lag,n-lag);
for i=1:n-lag
    inputs(:,i)=input(i:i+lag-1)';
end
targets=input(lag+1:end);

%创建网络
hiddenLayerSize = 10; %隐藏层神经元个数
net = fitnet(hiddenLayerSize);

% 避免过拟合，划分训练，测试和验证数据的比例
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

%训练网络
[net,tr] = train(net,inputs,targets);
%% 根据图表判断拟合好坏
yn=net(inputs);
errors=targets-yn;
figure;
ploterrcorr(errors);                      %绘制误差的自相关情况（20lags）
figure;
parcorr(errors);                          %绘制偏相关情况
[h,pValue,stat,cValue]= lbqtest(errors);         %Ljung－Box Q检验（20lags）
figure;
plotresponse(con2seq(targets),con2seq(yn));  %看预测的趋势与原趋势
figure;
ploterrhist(errors);                      %误差直方图
figure;
plotperform(tr);                          %误差下降线


%% 下面预测往后预测几个时间段
%预测步数为fn
f_in=input(n-lag+1:end)';
output=zeros(1,numnum);  %预测输出
% 多步预测时，用下面的循环将网络输出重新输入
for i=1:numnum
    output(i)=net(f_in);
    f_in=[f_in(2:end);output(i)];
end
end
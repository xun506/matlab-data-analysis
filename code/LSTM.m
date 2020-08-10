function Predict = LSTM(data,Fig3)

% Designed by ShengjieZhu
% 此示例说明如何使用长期短期记忆 (LSTM) 网络预测时序数据。
% 此方法需要NVIDA GPU参与运算，所以需要NVIDA硬件和驱动支持。

[m,~]=size(data);
x=0:1:m-1;
y=data(:,1);
y=y';
data=y;

numTimeStepsTrain = numel(data);
numTimeStepsTest = 30;
YPred = LSTMpredict(data,numTimeStepsTest);
Predict = YPred;
%% 使用 预测值 绘制 训练时序
% figure
axes(Fig3);cla reset;

idx = (1:length(data));
plot(x(1)-1+idx,data);hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(x(1)-1+idx,[data(numTimeStepsTrain) YPred],'.-');
hold off;grid on
xlabel('timeindex')
ylabel('timeseries')
title('长期短期记忆 (LSTM) 网络');
legend(["Observed" "Forecast"],'Location','SouthEast')




function YPred = LSTMpredict(dataTrain,numTimeStepsTest)
%% 标准化数据
% 为了获得较好的拟合并防止训练发散，将训练数据标准化为具有 零均值 和 单位方差
% 在预测时，您必须使用 与训练数据相同的参数 来标准化 测试数据
mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;

%% 准备预测变量和响应
% 要预测序列在将来时间步的值，请将响应指定为将值移位了一个时间步的训练序列。
% 也就是说，在输入序列的每个时间步，LSTM 网络都学习预测下一个时间步的值。
% 预测变量是没有最终时间步的训练序列。

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);


%% 定义 LSTM 网络架构
% 创建 LSTM 回归网络。
% 指定 LSTM 层有 200 个隐含单元。

numFeatures = 1;
numResponses = 1;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

% 指定训练选项。
% 将求解器设置为 'adam' 并进行 250 轮训练。
% 要防止梯度爆炸，请将梯度阈值设置为 1。
% 指定初始学习率 0.005，在 125 轮训练后通过乘以因子 0.2 来降低学习率。

options = trainingOptions('adam', ...
    'MaxEpochs',250, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');


%% 训练 LSTM 网络
% 使用 trainNetwork 以指定的训练选项训练 LSTM 网络。

net = trainNetwork(XTrain,YTrain,layers,options);


%% 预测将来时间步
% 要预测将来多个时间步的值，
% 请使用 predictAndUpdateState 函数一次预测一个时间步，
% 并在每次预测时更新网络状态。
% 对于每次预测，使用前一次预测作为函数的输入。

% 初始化网络状态
% 对训练数据 XTrain 进行预测。
net = predictAndUpdateState(net,XTrain);
% 用训练响应的最后一个时间步 YTrain(end) 进行第一次预测。
% 循环其余预测并将前一次预测输入到 predictAndUpdateState。
[net,YPred] = predictAndUpdateState(net,YTrain(end));
% 对于大型数据集合、长序列或大型网络，在 GPU 上进行预测计算通常比在 CPU 上快。
% 其他情况下，在 CPU 上进行预测计算通常更快。
% 对于单时间步预测，请使用 CPU。
% 要使用 CPU 进行预测，请将 predictAndUpdateState 的 'ExecutionEnvironment' 选项设置为 'cpu'。
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end

% 使用 先前计算的参数 对 预测 去标准化。
YPred = sig*YPred + mu;
end
end

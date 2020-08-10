function Predict = ARIMA(data,Fig3)

% ARIMA模型
% Designed by ShengjieZhu 

[m,~]=size(data);
x=0:1:m-1;
y=data(:,1);
y=y';
% hf2 = figure;

axes(Fig3);cla reset;
% set(hf2,'position',[1,1,1366/2,600]);
plot(x,y);
title('autoregressive integrated moving average')
grid on;
hold on;

aaa = y';

% 计算 1 阶差分
diff_a=diff(aaa);

% arima_i=0;
% diff_a=aaa(2:length(aaa));
% y_h_adf = adftest(aaa);
% y_h_kpss=kpsstest(aaa);
% while y_h_adf==0||y_h_kpss ==1
%     diff_a=diff(aaa);
%     arima_i=arima_i+1;
%     if arima_i>5
%         break;
%     end
% end

temp=ar(diff_a,2,'ls');  %利用最小二乘法估计模型的参数
predict_diff_a=predict(temp,diff_a);  %求原始数据的预测值,第二个参数必须为列向量
plot(x,[aaa(1); aaa(1:end-1)+predict_diff_a],'LineWidth',0.2);

% 预测值的个数 >0
predict_num = 30;
Predict_a = arima_forcast(aaa,predict_num);
Predict = Predict_a';
plot(x(end)+(1:length(Predict_a)),Predict_a,'LineWidth',1,'Color',[0 1 1]);
legend('actual','predict by Autoregressive','forecast by arima','Location','SouthEast')


%% autoregressive integrated moving average
function predict_a = arima_forcast(aaa,predict_num)
% 校验稳定，计算差分
% diff_a=diff(aaa);

arima_i=0;
y_h_adf = adftest(aaa);
y_h_kpss=kpsstest(aaa);
while y_h_adf==0&&y_h_kpss ==1
    diff_a=diff(aaa);
    arima_i=arima_i+1;
    if arima_i>5
        break;
    end
end


[r,m] = decide_order(diff_a,arima_i);

%% Mdl = arima(p,D,q)
% 建立一个ARIMA(p,D,q)模型
% 从1到p的非季节性AR多项式滞后
% D次非季节性积分多项式滞后
% 从1到q的非季节性MA多项式滞后
% Autoregressive Integrated Moving Average
spec2 = arima(r,0,m);

%% [EstMdl,EstParamCov,logL,info] = estimate(Mdl,y)
% 根据观察到的单变量时间序列y
% 使用最大似然法估计ARIMA(p,D,q)模型Mdl的参数
% EstMdl 存储结果的ARIMA模型
% EstParamCov 与估计参数相关的方差-协方差矩阵
% logL 优化的loglikelihood目标函数
[EstMdl,EstParamCov,logL] = estimate(spec2,diff_a,'Display','off');

%% Y = forecast(Mdl,numperiods,Y0,Name,Value) 
% 使用完全指定的VAR(p)模型Mdl，返回在长度numperiods预测范围内的
% 最小均方误差(MMSE)预测(Y)路径。
% 预测的响应代表预采样数据Y0的延续。
% 求 w 的预报值
w_Forecast = forecast(EstMdl,predict_num,'Y0',diff_a);

%% 计算原始数据的预测值
predict_a=aaa(end)+cumsum(w_Forecast);
end

function [r,m] = decide_order(diff_a,arima_i)
% 利用 AIC 准则定阶
% 计算差分后的数据个数
length_diff_a=length(diff_a);
% 初始化最小的 aic
aicmin=inf;
for i=0:3
    for j=0:3
        % 指定模型的结构
        spec = arima(i,arima_i,j);
        % 拟合参数
        [~,EstParamCov,logL] = estimate(spec,diff_a,'Display','off');
        % 计算拟合参数的个数
        numParams = sum(any(EstParamCov));
%         计算 Akaike and Bayesian Information Criteria
%         [aic,bic] = aicbic(logL,numParam,numObs) 
%         logL 优化的loglikelihood函数值
%         the sample sizes associated with each logL value
        [aic,bic]=aicbic(logL,numParams,length_diff_a);
        % 显示计算结果
        fprintf('R=%d,M=%d,AIC=%f,BIC=%f\n',i,j,aic,bic);
        % 保存 aic 最小的那组 R 和 M
        if aic<aicmin
            aicmin = aic;
            r=i;    m=j;
        end
    end
end
end
end
function DataClass = DataClassifier(SourceData,n0,WaveletMethod,SubFig2)
% input: 时间序列
% output: 数据类别
% 判别分析(决策树)-有监督分类

%% 判断是否平稳
ClassFlag = Stability(SourceData,n0,WaveletMethod);   %判断是否平稳

%% 
if ClassFlag == 1
    DataClass = 1;                          
else
    ClassFlag = Periodicity(SourceData,SubFig2);               %判断是否周期
    if ClassFlag == 1
         DataClass = 2; 
    else
        DataClass = 3; 
    end                                      %DataClass=1平稳，2周期，3非周期
end
end
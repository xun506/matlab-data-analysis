function [DataClass,ErrorList1] = AbnormalAnalysis(SourceData,ts,t0,n0,WaveletMethod,Fig1_2,Fig1_3);
%用来从数据分类的3种情况来分析异常值、
%data:数据
%ts:是否使用学习阈值，1：用 0：不用
%t0:%概率阈值

SubFig2 = Fig1_2;
title(SubFig2,'分类是否为周期图形');
SubFig3 = Fig1_3;
title(SubFig3,'预警位置标记图');

%% 数据分类器DataClass=1平稳，2周期，3非周期
DataClass = DataClassifier(SourceData,n0,WaveletMethod,SubFig2);
switch DataClass
    case 1
        ErrorList1 = setthreshold(SourceData,ts,t0,SubFig2,SubFig3);           %平稳数据用
    case 2
        ErrorList1 = setyear_on_year(SourceData,ts,t0,SubFig3);              %周期数据
    case 3
        ErrorList1 = setmonth_on_month(SourceData,ts,t0,SubFig3);            %非周期数据
end
end
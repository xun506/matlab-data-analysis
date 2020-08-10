function StabilityFlag = Stability(SourceData,n0,WaveletMethod)
% input: 时间序列
% output: flag 0 非平稳，1是平稳

std_global = std(SourceData);          %std_global 原始数据的标准差，表示全局波动情况

[~,cH]=dwt(SourceData,WaveletMethod);  %采用db4小波并对信号进行一维离散小波分解。

std_local = std(cH);             %std_local为小波变换结果高频部分的标准差，表示局部波动情况


n = std_global/std_local;

if n>n0      % flag 0 非平稳，1是平稳
    StabilityFlag = 0;
else
    StabilityFlag = 1;
end


end
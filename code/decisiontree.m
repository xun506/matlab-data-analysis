function decisiontree(DataClass,ts,t0,n0,WaveletMethod,alpha,ErrorList1,ErrorList2,FuncChoose,Predict,HR)
% 写入日志
% 发送给用户
% 执行下一步任务
switch DataClass
    case 1
        DataClass="读取的数据类型为：平稳数据";
    case 2
        DataClass="读取的数据类型为：周期数据";
    case 3
        DataClass="读取的数据类型为：非周期数据";
end

fid =fopen('../log/data.log','a');
t=datetime('now','TimeZone','local','Format','d-MM-y HH:m:ss z');
fprintf(fid,'\n%s\n',t);
fprintf(fid,'%s\n',DataClass);

if ts
    fprintf(fid,'是否使用学习阈值：是\n');
else
    fprintf(fid,'是否使用学习阈值：否\n');
end
fprintf(fid,'概率阈值为：%f\n稳定性判断阈值：%f\n本次采用的方法是：%s\n',t0,n0,WaveletMethod);
fprintf(fid,'Holt-Winters参数设置：alpha=%f\n',alpha);

fprintf(fid,'固定/学习阈值方法异常分析得到的错误数据编号:\n');
fprintf(fid,'%s\n',num2str(ErrorList1));
if (HR)
    fprintf(fid,'霍尔特-温特（Holt-Winters）方法异常分析得到的错误数据编号:\n');
else
    fprintf(fid,'径向基函数（RBF神经网络）方法异常分析得到的错误数据编号:\n');
end
fprintf(fid,'%s\n',num2str(ErrorList2));

switch FuncChoose
    case 1
        fprintf(fid,'数据走向预测：采用Autoregressive Integrated Moving Average model模型进行预测\n');
        fprintf(fid,'预测将来数据为：%s\n',num2str(Predict));
    case 2
        fprintf(fid,'数据走向预测：采用Back Propagation Neural Network模型进行预测\n');
        fprintf(fid,'预测将来数据为：%s\n',num2str(Predict));
    case 3
        fprintf(fid,'数据走向预测：采用Long short-term memory,LSTM模型进行预测\n');
        fprintf(fid,'预测将来数据为：%s\n',num2str(Predict));
    otherwise
        fprintf(fid,'数据走向预测：未使用模型进行预测\n');
end

fclose(fid);


end
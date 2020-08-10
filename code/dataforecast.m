function Predict = dataforecast(data,Fc,Fig3)
%用来判定是否需要进行数据预测以及用什么方法预测

switch Fc 
    case 1
        Predict = ARIMA(data,Fig3);
    case 2
        Predict = BP(data,Fig3);
    case 3
        Predict = LSTM(data,Fig3);
    otherwise
        Predict = 0;
        axes(Fig3);cla reset;
        pic = imread('pic.jpg');
        image(pic);
        disp("No prediction");
end

end
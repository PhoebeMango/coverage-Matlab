function [totalCount] = objectFunc(v,timePeriod,userNum)
%OBJECTFUNC 此处显示有关此函数的摘要
%   此处显示详细说明
    r=10^6;
    y=v(1:timePeriod*userNum);
    y=reshape(y,userNum,timePeriod)';
    ysquare=y.^2;
    yminus=1-y;
    yms=yminus.^2;
    total=ysquare.*yms;
    totalCount=-sum(sum(y))+r*sum(sum(total));
end


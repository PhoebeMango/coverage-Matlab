function [Result] = func(v,initY,timePeriod,userNum,r)
%FUNC 此处显示有关此函数的摘要
%   此处显示详细说明
    
    y=v(1:timePeriod*userNum)';
    y=reshape(y,timePeriod,userNum);
    for n=1:timePeriod
        for k=1:userNum
            re(n,k)=r*y(n,k)^4+r*y(n,k)^2-y(n,k)-2*r*initY(n,k)^3-6*r*initY(n,k)^2*(y(n,k)-initY(n,k));
        end
    end
    
    Result=sum(sum(re));
end


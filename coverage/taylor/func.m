function [Result] = func(v,initY,timePeriod,userNum,r)
%FUNC �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    
    y=v(1:timePeriod*userNum)';
    y=reshape(y,timePeriod,userNum);
    for n=1:timePeriod
        for k=1:userNum
            re(n,k)=r*y(n,k)^4+r*y(n,k)^2-y(n,k)-2*r*initY(n,k)^3-6*r*initY(n,k)^2*(y(n,k)-initY(n,k));
        end
    end
    
    Result=sum(sum(re));
end


function [totalCount] = objectFunc(v,timePeriod,userNum)
%OBJECTFUNC �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    r=10^6;
    y=v(1:timePeriod*userNum);
    y=reshape(y,userNum,timePeriod)';
    ysquare=y.^2;
    yminus=1-y;
    yms=yminus.^2;
    total=ysquare.*yms;
    totalCount=-sum(sum(y))+r*sum(sum(total));
end


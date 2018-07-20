function [c,ceq] = constraint(v,InitUav,FinalUav,timePeriod,userNum,userX,userY,totalPower,Vmax,userCoverage)
%CONSTRAINT 此处显示有关此函数的摘要
%   此处显示详细说明
    
    y=v(1:timePeriod*userNum);
    y=reshape(y,userNum,timePeriod)';
    uavTrajec=v(timePeriod*userNum+1:timePeriod*userNum+timePeriod*2);
    uavTrajec=reshape(uavTrajec,2,timePeriod)';
    power=v(timePeriod*(userNum+2)+1:timePeriod*(userNum+2)+timePeriod*userNum);
    power=reshape(power,userNum,timePeriod)';
    
    for k=1:userNum
        for n=1:timePeriod
            D(n,k)=hypot(uavTrajec(n,1)-userX(k),uavTrajec(n,2)-userY(k));
        end
    end
    
    ceq=[];
    
    q=[InitUav; uavTrajec; FinalUav];
    for n=1:timePeriod+1
        c1(n)=(q(n+1,1)-q(n,1))^2+(q(n+1,2)-q(n,2))^2-Vmax;
    end
    
    for n=1:timePeriod
        for k=1:userNum
            c2(n,k)=userCoverage-log(1+power(n,k)/D(n,k)^2)-userCoverage*(1-y(n,k));
        end
    end
    
    c=[c1,c2(:)'];
    
end


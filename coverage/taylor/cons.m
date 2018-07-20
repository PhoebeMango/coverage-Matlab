function [c,ceq] = cons(v,userX,userY,initPower,initUavX,initUavY,InitUav,FinalUav,userNum,timePeriod,userCoverage,r,Vmax,para)
%CONS 此处显示有关此函数的摘要
%   此处显示详细说明
    y=v(1:timePeriod*userNum)';
    y=reshape(y,timePeriod,userNum);
    
    IterationPower=v(timePeriod*userNum+1:2*timePeriod*userNum)';
    IterationPower=reshape(IterationPower,timePeriod,userNum);
    
    IterationUavX=v(2*timePeriod*userNum+1:2*timePeriod*userNum+timePeriod);
    IterationUavY=v(2*timePeriod*userNum+timePeriod+1:2*timePeriod*userNum+2*timePeriod);
    
    ceq=[];
    
    c(1)=(IterationUavX(1)-InitUav(1))^2+(IterationUavY(1)-InitUav(2))^2-Vmax^2;
    for n=1:timePeriod-1
        c(n+1)=(IterationUavX(n+1)-IterationUavX(n))^2+(IterationUavY(n+1)-IterationUavY(n))^2-Vmax^2;
    end
    c(timePeriod+1)=(IterationUavX(timePeriod)-FinalUav(1))^2+(IterationUavY(timePeriod)-FinalUav(2))^2-Vmax^2;
    
    for n=1:timePeriod
        for k=1:userNum
            initD(n,k)=sqrt((initUavX(n)-userX(k))^2+(initUavY(n)-userY(k))^2);
            iterD(n,k)=norm([(IterationUavX(n)-userX(k)) (IterationUavY(n)-userY(k))]);
            c2(n,k)=userCoverage-userCoverage*(1-y(n,k))-...
                log(1+initPower(n,k)/(initD(n,k)^para))+...
                (initPower(n,k)^2)/(initD(n,k)^(2*para)+(initD(n,k)^para)*initPower(n,k))*...
                (iterD(n,k)^para/IterationPower(n,k)-(initD(n,k)^para)/initPower(n,k));
        end
    end
    
    c=[c c2(:)'];
  
    
end


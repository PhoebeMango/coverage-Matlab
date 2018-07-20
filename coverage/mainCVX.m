%the formulations have been written but dut to CVX DCP it cannot run

% (iterDpara(n,k)*inv_pos(IterationPower(n,k))-initD(n,k)^para/initPower(n,k))>=userCoverage-r*(1-y(n,k));
% Disciplined convex programming error:
%     Cannot perform the operation: {convex} .* {convex}


userNum=10;
timePeriod=100;
userCoverage=3;
totalPower=100;
Vmax=10;
para=2;

InitUav=[0,0];
FinalUav=[101,101];

userX=linspace(1,100,userNum);
userY=linspace(1,100,userNum);

r=10^6;

initY=zeros(timePeriod,userNum);
initPower=zeros(timePeriod,userNum);
initPower(:)=10;

initUavX=linspace(1,100,timePeriod);
initUavY=initUavX;

for k=1:userNum
    for n=1:timePeriod
        initD(n,k)=sqrt((initUavX(n)-userX(k))^2+(initUavY(n)-userY(k))^2);
    end
end
cvx_begin
    variables y(timePeriod,userNum) IterationPower(timePeriod,userNum)
    variables IterationUavX(timePeriod) IterationUavY(timePeriod)
    expression object
    expression iterD
    expression iterDpara
    for n=1:timePeriod
        for k=1:userNum
            object(n,k)=r*y(n,k)^4+r*y(n,k)^2-y(n,k)-2*r*initY(n,k)^3-6*r*initY(n,k)^2*(y(n,k)-initY(n,k));
        end
    end
    minimize(sum(sum(object)))
    
    subject to
        sum(sum(IterationPower))<=totalPower
        (IterationUavX(1)-InitUav(1))^2+(IterationUavY(1)-InitUav(2))^2<=Vmax
        (IterationUavX(n)-FinalUav(1))^2+(IterationUavY(n)-FinalUav(2))^2<=Vmax
        for n=1:timePeriod-1
            (IterationUavX(n+1)-IterationUavX(n))^2+(IterationUavY(n+1)-IterationUavY(n))^2<=Vmax;
        end
        
        for n=1:timePeriod
            for k=1:userNum
                initD(n,k)=sqrt((initUavX(n)-userX(k))^2+(initUavY(n)-userY(k))^2);
                iterD(n,k)=norm([(IterationUavX(n)-userX(k)) (IterationUavY(n)-userY(k))]);
                iterDpara(n,k)=square_pos(iterD(n,k));
                log(1+initPower(n,k)^2/pow_p(initD(n,k),para))-...
                (initPower(n,k)^2/(initD(n,k)+initD(n,k)*initPower(n,k)))*...
                (iterDpara(n,k)*inv_pos(IterationPower(n,k))-initD(n,k)^para/initPower(n,k))>=userCoverage-r*(1-y(n,k));
            end
        end
        y>=0
        y<=1
        
        
    
cvx_end
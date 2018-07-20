userNum=5;
timePeriod=100;
userCoverage=20;
totalPower=10000;
Vmax=5;
para=2;
r=10^6;

InitUav=[0,0];
FinalUav=[101,101];

% userX=linspace(1,100,userNum);
% userY=linspace(1,100,userNum);
userX=unidrnd(100,1,userNum);
userY=unidrnd(100,1,userNum);

initY=zeros(timePeriod,userNum);
initPower=zeros(timePeriod,userNum);
initPower(:)=10;

% initUavX=linspace(2,99,timePeriod);
% initUavY=initUavX;
initUavX=unidrnd(99,1,timePeriod);
initUavY=unidrnd(99,1,timePeriod);

% x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
maxVsize=timePeriod*2*userNum+2*timePeriod;
A=zeros(1,maxVsize);
A(timePeriod*userNum+1:2*timePeriod*userNum)=1;
b=totalPower;

initV=ones(1,maxVsize);
initV(1:timePeriod*userNum)=round(rand(1,timePeriod*userNum));
initV(timePeriod*userNum+1:2*timePeriod*userNum)=10;
initV(2*timePeriod*userNum+1:2*timePeriod*userNum+timePeriod)=initUavX+0.1;
initV(2*timePeriod*userNum+timePeriod+1:2*timePeriod*userNum+2*timePeriod)=initUavY+0.1;

lb=zeros(1,maxVsize);
lb(2*timePeriod*userNum+1:2*timePeriod*userNum+2*timePeriod)=-inf;
ub=inf(1,timePeriod*(2*userNum+2));
ub(1:timePeriod*userNum)=1;
ub(timePeriod*userNum+1:2*timePeriod*userNum)=totalPower;

options=optimoptions('fmincon','Algorithm','sqp','MaxFunEvals',1000000,'Display','off');

[solution,result,exitflag]=fmincon( @(v)func(v,initY,timePeriod,userNum,r),initV,A,b,[],[],lb,ub,...
    @(v)cons(v,userX,userY,initPower,initUavX,initUavY,InitUav,FinalUav,userNum,timePeriod,userCoverage,r,Vmax,para),options);

y=solution(1:timePeriod*userNum)';
y=reshape(y,timePeriod,userNum);

IterationPower=solution(timePeriod*userNum+1:2*timePeriod*userNum)';
IterationPower=reshape(IterationPower,timePeriod,userNum);

IterationUavX=solution(2*timePeriod*userNum+1:2*timePeriod*userNum+timePeriod);
UavX=[InitUav(1) IterationUavX FinalUav(1)];
IterationUavY=solution(2*timePeriod*userNum+timePeriod+1:2*timePeriod*userNum+2*timePeriod);
UavY=[InitUav(2) IterationUavY FinalUav(2)];

for n=1:timePeriod
    for k=1:userNum
        iterD(n,k)=norm([(IterationUavX(n)-userX(k)) (IterationUavY(n)-userY(k))]);
        inequationL(n,k)=log(1+IterationPower(n,k)/(iterD(n,k)^para));
        ineuqationR(n,k)=userCoverage*(1-y(n,k));
    end
end

        
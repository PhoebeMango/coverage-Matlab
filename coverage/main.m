userNum=5;
timePeriod=100;
userCoverage=1;
totalPower=10000;
Vmax=10;

InitUav=[0,0];
FinalUav=[100,100];

userX=linspace(1,100,userNum);
userY=linspace(1,100,userNum);

%v=[y uavTrajec power]-n*k n*2 n*k
inity=ones(timePeriod,userNum);
initY=inity';
initY=initY(:)';

% initUav=randi(100,timePeriod,2);
% initUav=initUav(:)';

inituav=linspace(1.1,9,timePeriod)';
initTrajec=[inituav inituav];
initUav=initTrajec';
initUav=initUav(:)';

initpower=zeros(1,timePeriod*userNum);
initpower(:)=10;

A=zeros(1,timePeriod*(userNum+2)+timePeriod*userNum);
A(timePeriod*(userNum+2)+1:timePeriod*(userNum+2)+timePeriod*userNum)=1;

initv=[initY initUav initpower];
lb=zeros(1,timePeriod*(userNum+2)+timePeriod*userNum);
ub=ones(1,timePeriod*(userNum+2)+timePeriod*userNum);
ub(timePeriod*userNum+1:timePeriod*userNum+timePeriod*2)=inf;
ub(timePeriod*(userNum+2)+1:timePeriod*(userNum+2)+timePeriod*userNum)=totalPower;

Options=optimoptions('fmincon','MaxFunEvals',1000000,'Display','off');
[solution,count,exitflag]=fmincon(@(v)objectFunc(v,timePeriod,userNum),initv,A,totalPower,[],[],lb,ub,@(v)constraint(v,InitUav,FinalUav,timePeriod,userNum,userX,userY,totalPower,Vmax,userCoverage),Options);
 y=solution(1:timePeriod*userNum);
 y=reshape(y,userNum,timePeriod)';
 uavTrajec=solution(timePeriod*userNum+1:timePeriod*userNum+timePeriod*2);
 uavTrajec=reshape(uavTrajec,2,timePeriod)';
 power=solution(timePeriod*(userNum+2)+1:timePeriod*(userNum+2)+timePeriod*userNum);
 power=reshape(power,userNum,timePeriod)';






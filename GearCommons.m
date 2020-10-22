function [zopt,fopt] = GearCommons(BC,q)
%% Definitions

LB = BC(1,1:8);
UB = BC(2,1:8);

%% Optimization Common Parameters

z0 = (LB+UB)/2;
A=[];b=[];Aeq=[];beq=[];
options= optimset('Display','off');

%% Optimize Gear Commonalities

[zopt,fopt] = fmincon('objfun_A',z0,A,b,Aeq,beq,LB,UB, ...
    'nonlcon_A',options,q,BC);

end










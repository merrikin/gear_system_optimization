function [volume, dim_opt,dim_out,y] = DimOpt(z,q,BC)
%% Definitions

% objective variables from 1st stage
M = z(1);           % Modulus of gears & pinions
PA = z(2);          % pressure angle
F = z(3);           % face width            
phi = z(4);         % helix angle         
hw = z(5);          % hub width (mm)
bd = z(6);          % bore diameter (mm)
Tt = z(7);          % tooth thickness
snt = z(8);         % smallest number of teeth

% gear train data
GR = q(1);          % gear ratio
num_sets = q(2);    % number of gear/pinion sets
%snt = q(3);         % smallest number of teeth
tq = q(3);          % input torque
sp = q(4);          % input speed
                          
% material data
E = q(5);           % young's modulus
v = q(6);           % poison's ratio
s_a = q(7);         % allowable stress
s_ac = q(8);        % allowable contact stress
msf = q(9);        % material safety factor

% loading factors
kv = q(10);         % dynamic/velocity factor
ko = q(11);         % overload factor
km = q(12);         % load distribution factor
ks = q(13);         % size factor
kb = q(14);         % rim thickness factor

w = ...             % pass data for gear train calculation
    [GR,num_sets,tq,sp,snt];

k = ...             % pass data for analysis
    [M,PA,F,phi,hw,bd,Tt,E,v,s_a,s_ac,msf,kv,ko,km,ks,kb];


global J P
        
%% Obtain Gear Train Data

[gear_data] = GearTrainCalc(w);

y = gear_data.'; % pass gear train data 

[~, n] = size(gear_data);

%% Optimization Parameters

LB = BC(1,9:12);
UB = BC(2,9:12);

x0 = [ ...          % initial guess - average of LB and UB
    0.5*(LB(1)+UB(1)),0.5*(LB(2)+UB(2)),0.5*(LB(3)+UB(3)),...
    0.5*(LB(4)+UB(4))];

A=[];b=[];Aeq=[];beq=[];
options = optimset('TolCon',1e-06,...
    'Algorithm','sqp','Display','off');

Data_out1 = [];Data_out2 = [];Dim_out1 = [];Dim_out2 = [];

%% Optimize Unique Gear Parameters

for P = 0:1:1

    for J = 1:n

        [xopt,~] = fmincon('objfun_B', x0,A,b,Aeq,beq,LB,UB, ...
            'nonlcon_B', options, y,k);

        Xopt(J,:) = xopt; %#ok<AGROW>

        [Data_out(J,:), Dim_out(J,:)] = Gear_Analysis(xopt,y,k); %#ok<AGROW>

    end

    if P < 1
        Data_out1 = Data_out;
        Dim_out1 = Dim_out;
        Xopt1 = Xopt;
    elseif P == 1
        Data_out2 = Data_out;
        Dim_out2 = Dim_out;
        Xopt2 = Xopt;
    end
    
end

data_out = [Data_out1;Data_out2];
dim_out = [Dim_out1; Dim_out2];

%% Output

volume = data_out(1:n,8:11);
dim_opt = [Xopt1;Xopt2];

end
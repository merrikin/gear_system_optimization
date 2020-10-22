function [data_out, dim_out] = Gear_Analysis(x,y,k)
%% Definitions

global J P;

StartStop = (1*abs(P-1)+P*2); % toggles between gear/pinion dep. on P

T = y(J,StartStop);    % number of teeth
tq = y(J,3);           % subject's torque
sp = y(J,4);           % subject's velocity
GR = y(J,5);           % subject's gear ratio

M = k(1);              % Modulus of gears & pinions
PA = k(2);             % pressure angle
F = k(3);              % face width
phi = k(4);            % helix angle
hw = k(5);             % hub width (mm)
bd = k(6);             % bore diameter (mm)
Tt = k(7);             % tooth thickness (mm)
                                                  
% material data
E = k(8);               % young's modulus
v = k(9);               % poison's ratio
s_a = k(10);             % allowable stress
s_ac = k(11);           % allowable contact stress
msf = k(12);            % material safety factor

% loading factors
kv = k(13);             % dynamic/velocity factor
ko = k(14);             % overload factor
km = k(15);             % load distribution factor
ks = k(16);             % size factor
kb = k(17);             % rim thickness factor

% optimized parameters
hd = x(1);              % hub OD
rd = x(2);              % rim diameter
rt = x(3);              % root diameter
sp_w = x(4);            % spoke width
c = [1];                 % place holder


%% Intermediate Calculations

a = ...                 addendum
    0.925e-3*M;

d = ...                 dedendum
    a; 

Pd = ...                pitch diameter
     M*T*(10^-02);
    
Wt = ...                tangential load
    tq/(0.5*Pd);    

Pt = (Pd*pi)/T;

Px = Pt/(tan(phi));

cr = ...                contact ratio
    F/Px;   

T_h = ...               tooth height
    a+d;

%% Stress Calculations

% contact stress
    I =...              contact stress form factor
        ((cos(PA)*sin(PA))/2) * (GR/(GR-1));
    
    cp =...             elastic coefficient factor
        0.564*sqrt( ...
        (1/(((1-v^2)/E)+(1-v^2)/E)));
    
    k_sc =...           contact stress loading factors
        kv*ko*0.93*km;
    
    s_c =...            contact stress
        cp* sqrt(...
        (Wt/(F/(cos(phi)*Pd*I)))*...
        ((cos(phi))/(0.95*cr*k_sc)));
%__________________________________________________________________________

% bending stress
    k_sb =...           bending stress loading factors
        ko*ks*km*kb*kv;

    s_b =...            bending stress
        (Wt*Pd)*k_sb/ ...
        (F*Tt);
%__________________________________________________________________________

% hub stress
    h_tau = ...
        (Wt*(Pd-hd)*(hd*0.5))/ ...
        ((pi/32)*(hd^4 - bd^4));
    
    h_sig_y = ...
        (Wt/(F*(hd-bd)));


    s_h =...            hub stress, max shear
        sqrt((((0-h_sig_y)/2)^2) + ...
        h_tau^2);
    
%__________________________________________________________________________

% rim stress
    r_s =...            rim stress
        Wt/ ...
        (F*(rt-rd));
%__________________________________________________________________________

% spoke stress
    r_sp_a =...             required spoke area
        (msf*s_h)/(s_a);

    num_sp =...             number of spokes
        round(...
        ((r_sp_a*hd*pi)/ ...
        sp_w)+ ...
        0.5);
    
    if num_sp < 3
        num_sp = 3;
    end
    

    s_s_p =...          proximal spoke stress
        (1.5*(Wt*0.5*(Pd-rd)))*num_sp/ ...
        ((2*F)*(sp_w^2)/6);
    
    s_s_d =...          distal spoke stress
        (1.5*(Wt*0.5*(Pd-hd)))*num_sp/ ...
        ((2*F)*(sp_w^2)/6);

%% Volume Calculations

Td = ...                % tooth depth
    F/cos(phi);

Tf = ...                % tooth face area
    2*(Tt*(a+d) - 0.5*(tan(PA)*(a^2)) + 0.5*(tan(PA)*(d^2)));% + ...
  %  c*(Tt*d*tan(PA)));

Hv = ...                % hub volume
    (pi/4)*((hd^2)-(bd^2))*(hw+F);

Spv = ...               % total spokes volume
    num_sp*( ...
    (rd-hd)*(F*sp_w));
    

Rv = ...                % rim to root volume
    (pi/4)*(rt^2-rd^2)*F;

Tv = ...                % teeth volume
    Td*Tf;
    
%% Data Output

data_out = [ ...
    s_c, s_b, s_h, r_s, num_sp, s_s_p, s_s_d, ...
    Hv, Spv, Rv, Tv ...
    ];

dim_out = [ ...
    Pd, Wt, Pt, cr, a,c,d, T_h,T,num_sp ...
    ];

end
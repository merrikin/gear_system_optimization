function [C,Ceq] = nonlcon_B(x,y,k)
%% Definitions

% call for gear analysis data
[data_out,dim_out] = Gear_Analysis(x,y,k);

% analysis parameters
s_c = data_out(1);         % contact stress
s_b = data_out(2);         % bending stress
s_h = data_out(3);         % hub stress
r_s = data_out(4);         % rim stress
num_sp = data_out(5);      % number of spokes
s_s_p = data_out(6);       % spoke stress - proximal
s_s_d = data_out(7);       % spoke stress - distal
d = dim_out(7);            % dedendum
T = dim_out(9);            % number of teeth

% input parameters
F = k(3);                  % face width
bd = k(6);                 % bore diameter (mm)
Tt = k(7);                 % tooth thickness
                                                  
% material data
s_a = k(10);               % allowable stress
s_ac = k(11);              % allowable contact stress

% optimized parameters
hd = x(1);                 % hub OD
rd = x(2);                 % rim diameter
rt = x(3);                 % root diameter
sp_w = x(4);               % spoke width

%% Inequlity Constraints
C(1) = s_c - s_ac;      % tooth contact stress < allowable contact stress
C(2) = s_b - s_a;       % tooth bending stress < allowable
C(3) = s_h - s_a;       % hub stress < allowable
C(4) = r_s - s_a;       % rim stress < allowable
C(5) = s_s_p - s_a;     % proximal spoke stress < allowable
C(6) = s_s_d - s_a;     % distal spoke stress < allowable
C(7) = bd - hd;         % bore diam < hub diam
C(8) = (hd + 0.001) - rd;   % hub diam < rim diam less 1 mm
C(9) = (rd + 0.001) - rt;   % rim diam < root diam less 1 mm
C(10) = sp_w - (hd*0.5*sin(1.0472)*2);  % spoke width < 1/3 circumference
C(11) = 3 - num_sp;     % there are more than 3 spokes

%% Equality Constraints

Ceq(1) = (Tt*2*T) - (pi*(rt+2*(d)));    

end
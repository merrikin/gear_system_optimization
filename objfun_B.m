function [total_volume] = objfun_B(x,y,k)
%% Definitions

% call for analysis data
[data_out] = Gear_Analysis(x,y,k);

% define parameters
Hv = data_out(8);          % hub volume
Spv = data_out(9);         % spoke volume
Rv = data_out(10);         % rim volume
Tv = data_out(11);         % tooth volume

%% Objective Function

total_volume = Hv + Spv + Rv + Tv;

end
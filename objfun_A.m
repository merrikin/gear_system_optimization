function [total_volume] = objfun_A(z,q,BC)
%% Definitions

% call for analysis data
[volume] = DimOpt(z,q,BC);

% define parameters
Hv = volume(1);         % hub volume
Spv = volume(2);        % spoke volume
Rv = volume(3);         % rim volume
Tv = volume(4);         % tooth volume

%% Objective Function

total_volume = Hv + Spv + Rv + Tv;

end
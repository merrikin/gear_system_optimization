function [gear_data] = GearTrainCalc(gt)
%% Inputs
GR = gt(1);             % gear ratio
NS = gt(2);             % number of gear/pinion sets
tq = gt(3);             % input torque
sp = gt(4);             % input velocity (pitch line speed)
snt = gt(5);            % smalled number of teeth alloted

%% Definitions and allocations

gm = GR^(1/NS);         % gear multiplier

pinions = zeros(1,NS);    
gears = zeros(1,NS);
n = 0;

%% Generate prelininary pinions and gears

for i = 1:NS    
    pinions(i) = ((round((gm^n)-0.5,0)) / (round((gm^n)-0.5,0)) )*snt;
    n = n+1;
    gears(i) = (round( (gm^n) / (round((gm^(n-1))-0.5,0))))*snt; 
end
gr_actual = prod(gears) / prod(pinions);


%% Test and adjust the gear ratio

n = 1;
if NS>1
    for i = 1:NS                % check for gear/pinion sizing interference

        if gears(n)+1 >= gears(n+1)

            while gears(n)+1 >= gears(n+1)
                gears(n+1) = gears(n+1)+2;
            end

            gr_actual = prod(gears) / prod(pinions);

            if gr_actual > GR
                pinions(n) = pinions(n)+1;
            end
        end

        if n < NS-1
            n = n+1;
        end

        gr_actual = prod(gears) / prod(pinions);
    end
end
n = 1;
if gr_actual > GR           % reduce gear ratio to desired number
    
    while gr_actual > GR
        if gears(n)> snt
            gears(n) = gears(n)-1;
            gr_actual = prod(gears) / prod(pinions);
        end
                
        if gears(n) <= snt && gr_actual > GR
            n = n+1;
        end
    end
end
    
if gr_actual < GR           % ensure minimum gear ratio is met
    gears(n) = gears(n)+1;
    gr_actual = prod(gears) / prod(pinions);
end

%% Remove duplicate sets

gears = sort(gears, 'descend');
pinions = sort(pinions);

%n = NS+1;
for i = 1:NS
    n = numel(gears);
   if gears(n) == pinions(1)
       if i == 1
           fprintf('Warning: Removed duplicate sets.\n');
       end
       gears = gears(1:NS-i);
       pinions = pinions(2:(n));
   end
end

%% Sort gears for 

n = numel(gears);
for i = 2:(n-2)
   j = gears(i);
   gears(i) = gears(n);
   gears(n) = j;    
end

%% Torque and velocity calculations:

for i = 1:numel(gears)
    igr(i) = ( prod(gears(1:i))/ prod(pinions(1:i))); % intermittent gear ratio
end

tg = tq.*igr;               % torque on gears
vg = sp.*igr;               % pitch line speed of gears

%% Pass gear data:

gear_data = [gears;pinions;tg;vg;igr];

end
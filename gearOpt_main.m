% gearOpt_main
clc, clear all;

%% Information

% Author:       C.Merrikin
% Version:      1.0

% Background: 
        %
        %    Written as a final project for Numeric Optimization (ME423)
        % at Saint Martin's University in Lacey, WA.
        %
        %    This code is designed to accept certain gear train parameters
        % and material properties to produce an output of the optimal 
        % dimensions which minimize the volume of the gears for the 
        % purpose of having them 3D printed at an optimal cost.
        %
% Instructions:
        %
        %   1) Input:
        %       a) your desired gear ratio [GR]
        %       b) desired number of gear/pinion sets [num_sets]
        %       c) initial torque and velocity [tq,sp]
        %       d) Name your output file
        %
        %   2) Specify:
        %       a) material properties
        %       b) gear loading factors
        %
        %   3) Adjust (as needed):
        %       a) Printing Boundary Conditions as needed to fit
        %          the requirements of your print
        %       b) Gear Commonalities to suit design constraints
        %
% Output:
        % The script will publish the data for all of the generated gears
        % to an Excell file in the script's directory.

%% ---> START HERE <---
%%   1) User Defined Input

GR = 40;            % gear ratio
num_sets = 3;       % number of gear/pinion sets
tq = 10;            % input torque
sp = 12;            % input speed

FileOutName = 'Test.xls'; % output file name, include .xls at end

%%   2) User Specifications

% material data                                     Nylon 12:
E = 200e+09;        % young's modulus               E = 100e09
v = 0.25;           % poison's ratio                v = 0.43
s_a = 420e+06;      % allowable stress              s_a = 170e+06
s_ac = 300e+06;     % allowable contact stress      s_ac = 121e+06
msf = 2;            % material safety factor

% loading factors                                   Steel: 
kv = 1;             % dynamic/velocity factor       E = 200e+09
ko = 1;             % overload factor               v = 0.25
km = 1;             % load distribution factor      s_a = 420e+06
ks = 1;             % size factor                   s_ac = 300e+06
kb = 1;             % rim thickness factor

%%   3) User Adjustments

LB_common = [ ...   Gear Commonalities lower boundaries
    0.75,             ... modulus
    0.209,            ... pressure angle
    3e-03,            ... face width
    0,                ... helix angle
    3e-03,            ... hub width
    3e-03             ... bore diameter
    2e-03             ... tooth thickness (mm)
    7                 ... smallest number of teeth
    ];

UB_common = [ ...   Gear Commonalities upper boundaries
    2.5,              ... modulus
    0.419,            ... pressure angle
    50e-03,           ... face width
    0.785,            ... helix angle
    10e-03,           ... hub width
    12e-03,           ... bore diameter
    10e-03            ... tooth thickness (mm)
    15                ... smallest number of teeth
    ];

LB_printSize = [ ...    Printing Boundary Conditions lower
    9e-03,                ... hub OD (m)
    12e-03,               ... rim diameter (m)
    14e-03,               ... root diameter (m)
    1e-03,                ... spoke width -axial (m)
    ];

UB_printSize = [ ...    Printing Boundary Conditions upper
    150e-03,          ... hub OD (mm)
    150e-03,          ... rim diameter (mm)
    200e-03,          ... root diameter (mm)
    30e-03,           ... spoke width -axial (mm)
    ];

%% Data Compilation

q = [ ...           pass data for optimization
    GR,num_sets,tq,sp, ...
    E,v,s_a,s_ac,msf, ...
    kv, ko, km, ks, kb ...
    ];

CBC = [ ...         pass gear cominalities boundary conditions
    LB_common;UB_common];

PBC = [ ...         pass printing boundary conditions
    LB_printSize;UB_printSize];

BC = [ ...          pass boundary conditions
    CBC,PBC];   

%% Optimize Gear Commonalities

[zopt,fopt] = GearCommons( ...
    BC,q);

%% Compute Final Output

[volume,dim_opt,dim_out,y] = DimOpt( ...
    zopt,q,BC);

%% Save Dataset

[flag] = gearOpt_dataOut(zopt,dim_opt,dim_out,fopt,FileOutName);
fprintf(flag);

% SUMMARY OF WHAT THIS SCRIPT DOES
% 1) Read track_race_course.csv into a table T.
% - Uses: T.type, T.length_mm, T.diameter_mm
%
% 2) Define one skateboard setup:
% - deckLength_mm, wheelbase_mm, wheelDia_mm
% - Also define reference values:
% refWheelDia_mm, refWheelbase_mm, refCornerDia_mm
%
% 3) Define base speeds and exponents:
% - v_base_straight, v_base_corner (m/s)-->you need some speed to start
% with
% - a_roll, b_wb, c_Dseg (dimensionless)
%
% 4) Loop over each segment k:
% - Read segment length Lmm and determine if segment is a 'S' or 'C'
% - If straight:
% scaleD = (wheelDia_mm / refWheelDia_mm)^a_roll
% v = v_base_straight * scaleD
% If corner:
% Dseg = segDiammm(k) (mm)
% If Dseg <= 0, replace with refCornerDia_mm
% scaleDseg = (Dseg / refCornerDia_mm)^c_Dseg
% scaleWB = (refWheelbase_mm / wheelbase_mm)^b_wb
% scaleWD = (wheelDia_mm / refWheelDia_mm)^0.2
% v = sum of all segments
% - segSpeed(k) = v
% - segTime(k) = (Lmm/1000) / v % mm → m
% - cumDist(k) = cumulative sum of segment lengths
%
% 5) Compute totalTime
%
% 6) Plot:
% - Speed vs cumulative distance
%
%
% 7) Write onshape_board_configs.csv with:
% - ConfigName, deckLength, wheelbase, wheelDiameter
%%
clear; clc; close;

%% Read .csv into Table "T"
T = readtable("track_race_course.csv");

%% Define board parameters
deckLength_mm = 850;
wheelbase_mm = 192;
wheelDia_mm = 51;

% Reference board + speed parameters
refWheelDia_mm = 51;
refWheelbase_mm = 192;
refCornerDia_mm = 9000;

v_base_straight = 5.0; % m/s
v_base_corner = 3.7;    % m/s

a_roll = 0.6;
b_wb = 0.3;
c_Dseg = 0.3;

currDist_mm = 0; % preallocate currDist, use for cumDist later

% pre-allocates arrays for the different segments
segSpeed = zeros();
segTime = zeros();
cumDist = zeros(); 

corner = 0;
straight = 0;

%% Loop each line of .csv file. check segment for type, and do... something (to be figured out)
for i = 1:numel(T.type)
    
    L_mm = T.length_mm(i); % current length of segment
    currDist_mm = L_mm + currDist_mm; % sum of current seg length and the current total distance

    if T.type{i} == 'S' % 'S' = straight
        straight = straight + 1;
        scaleD = (wheelDia_mm / refWheelDia_mm) ^ a_roll;
        v = v_base_straight * scaleD;
    elseif T.type{i} == 'C' % 'C' = corner
        corner = corner + 1;
        Dseg = T.diameter_mm(i);
        if Dseg <= 0
            Dseg = refCornerDia_mm;
        end
        scaleDseg = (Dseg / refCornerDia_mm) ^ c_Dseg;
        scaleWB = (refWheelbase_mm / wheelbase_mm) ^ b_wb;
        scaleWD = (wheelDia_mm / refWheelDia_mm) ^ 0.2;
        v = v_base_corner * scaleDseg * scaleWB * scaleWD;
    end
% creates arrays for the segment speeds, time, and distance at certain points
segSpeed(i) = v;
segTime(i) = (L_mm / 1000) / v;
cumDist(i) = currDist_mm; 
end
fprintf("Corners = %d\n",corner)
fprintf("Straight = %d\n",straight)
%% Total Time of Course
totalTime = sum(segTime);

%% Plotting the data
figure(1);
plot((cumDist / 1000), segSpeed,'-o')
grid on;
title("Speed vs Distance (Total time = "+totalTime+" seconds)")
xlabel("Cumulative Distance (m)")
ylabel("Speed (m/s)")



%% Writing to an onshape-readable file
ConfigName = "Std Board";
skate = table(ConfigName, deckLength_mm, wheelbase_mm, wheelDia_mm);
writetable(skate,'onshape_board_configs.csv')
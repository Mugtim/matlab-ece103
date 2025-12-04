%% Get array length value
clear
close
clc 

% hardcoded for demonstration purpose
arrLen = 10; % determins the length of the fibonacci sequence array

% loop checks if value entered is greater than zero
if arrLen > 0
    %% Create Array to Hold Fibonacci Sequence
    fibVals = zeros(1,arrLen); % initializes an of length 1 to chosen length full of zeros
    fibVals(1) = 1;
    fibVals(2) = 1;
    % fibVals(1) and fibVals(2) are assigned with 1 and 1 to ensure proper
    % fibonacci calculation.

    xValues = 1:arrLen; % for length of x-axis on plot
    
    %% Index fibonacci sequence into fibonacci array
    for idx = 3:length(fibVals)
        fibVals(idx) = fibVals(idx - 1) + fibVals(idx - 2);
        % uses formula for fibonacci sequence, indexes into fibVals
    end
    
    %% Create 2 plots for linear and logarithmic
    
    figure(name = "linear") % gives figure unique identifier
    plot(xValues,fibVals,"Color","Green");
    
    figure(name = "logarithmic") % gives figure unique identifier
    semilogy(xValues,fibVals,"Color","Red");
    % uses logarithmic plotting 
else
    disp("Please enter a positive number")
    % kindly asks to be given a positive value
end

%% Step 1
clear
close % clear variables & console, close previous plots
clc

RL_start = 10; % 10 ohm start value
RL_end = 80; % 80 ohm end value
V = 110; % 110 volts
Rs_values = [30 45 60]; % no internal resistance
idx = 1; 

%% Step 2
RL = RL_start:0.5:RL_end; % vector from RL_start to _end

%% Step 3, 4, 5, 6, 7, 8, 9
while idx <= length(Rs_values)    

    % Calculate current; V = I*R, I = V / R, I = V / (Rs_n + RL)
    I = V ./ (Rs_values(idx) + RL);
    
    % Calculate power; P = I^2 * RL
    P = I.^2 .* RL;
    
    figure(idx)
    
    plot(RL,P,'green')
    xlabel('Load Resistance [Ohms]')
    ylabel('Power [Watts]')
    title("P vs. R_L with R_S = "+Rs_values(idx)+" Ohms")
    grid

    [P_max, index] = max(P);
    RL_max = RL(index);
    line([RL_max,RL_max],[P(1),P_max],"Color",'white',"LineStyle",'--')

    saveas(figure(idx),"plot_"+ idx +" "+ Rs_values(idx)+".png")
       
    idx = idx + 1;
end
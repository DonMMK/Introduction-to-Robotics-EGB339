% Solution for EGB339 prac for 2020

function [init_xy, dest_xy] = EGB339_prac_exam_group_16(dobot_sim, init_positions, dest_positions, use_vision)


%%
if use_vision == true
    
    
    % do computer vision on initial_positions and destination_positions arguments which are images
    
    % add your code here which should include move robot arm and capture image from sim %%
    
    % you will need to calculate the xy positions and return them at the end of this section of code
    % shapes_xy needs to be
    % init_shape_xy and dest_xy need to be of size 3 x 2 and an example is shown below
    init_xy = [0,0; 0,0; 0,0];
    dest_xy = [0,0; 0,0; 0,0];
    %%
    
else
    %% CODE NOTES
    % Real world coordinates are given as (X,Y,Z)
    % Use the d to convert to degrees cause matlab calcs in rad
    %close all; clear; clc
    %sync = false;
    %dobot_sim = coppeliaRobot('Dobot');
    %dobot_sim.startSim(sync);
    
    i = 1;
    while (i < 4)
        
        % Given that we are given the coordinates (Vison == False)
        %init_xy = [288e-3, 452e-3; 215e-3, 213.1e-3; 254.2e-3, 102.6e-3];
        
        %dest_xy = [273e-3, 328e-3; 145.6e-3, 157.6e-3; 93.7e-3, 82.1e-3];
        % Execute Pick
        
        % This section iterates through each start and end coordinates
        % to pick up each object and place at the desired location
        init_xy = init_positions;
        dest_xy = dest_positions;
        
        
        % Given Coordinates
        X = init_xy(i,1);
        Y = init_xy(i,2);
        Z = 50e-3; % cylinder height
        
        % Declare the constants
        link1 = 0.138;
        link2 = 0.135;
        link3 = 0.147;
        link4 = 0.060;
        link5 = 0.075;
        
        %To find the robot coodinates from the measured
        Xr = X - 80e-3;
        Yr = Y - 290e-3;
        
        % Code for executing the inverse kinematics (Joint Angles)
        %Theta 1
        theta1 = atan2d(Yr , Xr);
        
        %Theta 3
        vertical = Z + link5 - link1;
        horizontal = sqrt(Xr^2 + Yr^2)  - link4;
        lengthB = sqrt(vertical^2 + horizontal^2);
        A = (link2^2 + link3^2 - lengthB^2) / (2 * link2 * link3);
        theta3 = 90 - atan2d(sqrt(1 - A) , A);
        
        %Theta 2
        %thetaB = asind(  (link3 *(sin(90 - theta3)))/lengthB) ;
        G = (link2^2 + lengthB^2 - link3^2)/(2*link2*lengthB);
        thetaB = atan2d(sqrt(1-G^2), G);
        thetaA = atan2d(vertical, horizontal);
        theta2 = 90 - (thetaA + thetaB);
        
        %Theta 4
        theta4 = -theta2 - theta3;
        
        %Theta 5
        theta5 = 0;
        
        target = [theta1 theta2 theta3 theta4 theta5]
        dobot_sim.setJointPositions(target);
        
        dobot_sim.setSuctionCup(true);
        
        pause(8);
        
        % Lift up
        X = init_xy(i,1); Y = init_xy(i,2); Z = 3 * Z;
        Xr = X - 80e-3;
        Yr = Y - 290e-3;
        theta1 = atan2d(Yr , Xr);
        vertical = Z + link5 - link1;
        horizontal = sqrt(Xr^2 + Yr^2)  - link4;
        lengthB = sqrt(vertical^2 + horizontal^2);
        A = (link2^2 + link3^2 - lengthB^2) / (2 * link2 * link3);
        theta3 = 90 - atan2d(sqrt(1- A) , A);
        G = (link2^2 + lengthB^2 - link3^2)/(2*link2*lengthB);
        thetaB = atan2d(sqrt(1-G^2), G);
        thetaA = atan2d(vertical, horizontal); %asind(  (sin(90) * Z + link5 - link1) / lengthB  );
        theta2 = 90 - (thetaA + thetaB);
        theta4 = -theta2 - theta3;
        
        lifttarget = [theta1 theta2 theta3 theta4 theta5]
        dobot_sim.setJointPositions(lifttarget);
        
        pause(4);
        
        % Move to new location function
        Xend = dest_xy(i,1);
        Yend = dest_xy(i,2);
        Zend = Z/3 + 20e-3;
        
        Xr = Xend - 80e-3;
        Yr = Yend - 290e-3;
        
        theta1 = atan2d(Yr , Xr);
        
        vertical = Zend + link5 - link1;
        horizontal = sqrt(Xr^2 + Yr^2)  - link4;
        lengthB = sqrt(vertical^2 + horizontal^2);
        A = (link2^2 + link3^2 - lengthB^2) / (2 * link2 * link3);
        theta3 = 90 - atan2d(sqrt(1- A) , A);
        
        G = (link2^2 + lengthB^2 - link3^2)/(2*link2*lengthB);
        thetaB = atan2d(sqrt(1-G^2), G);
        thetaA = atan2d(vertical, horizontal);
        theta2 = 90 - (thetaA + thetaB);
        
        theta4 = -theta2 - theta3;
        
        theta5 = 0;
        
        %% Lift up from same position
        newtarget = [theta1 0 theta3 theta4 theta5]
        dobot_sim.setJointPositions(newtarget);
        pause(5);
        
        
        newtarget = [theta1 theta2 theta3 theta4 theta5]
        dobot_sim.setJointPositions(newtarget);
        
        
        
        pause(5);
        
        % Drop function
        
        dobot_sim.setSuctionCup(false);
        
        % Lift up
        lifttarget = [theta1 theta2-theta2 theta3 theta4 theta5]
        dobot_sim.setJointPositions(lifttarget);
        
        pause(3);
        
        i = i + 1;
    end
    
    
end
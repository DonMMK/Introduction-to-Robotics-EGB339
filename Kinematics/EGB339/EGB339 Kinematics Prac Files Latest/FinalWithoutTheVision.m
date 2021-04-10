%% Solution for EGB339 prac for 2020


function [init_xy, dest_xy] = EGB339_prac_exam_group_16(dobot_sim, init_positions, dest_positions, use_vision)


% Get the vision from chiran
if use_vision == true
    
    
    % do computer vision on initial_positions and destination_positions arguments which are images
    
    % add your code here which should include move robot arm and capture image from sim %%
    
    % you will need to calculate the xy positions and return them at the end of this section of code
    % shapes_xy needs to be
    % init_shape_xy and dest_xy need to be of size 3 x 2 and an example is shown below
    init_xy = [0,0; 0,0; 0,0];
    dest_xy = [0,0; 0,0; 0,0];
    
    
else
%     close all; clear; clc
%     sync = false;
%     dobot_sim = coppeliaRobot('Dobot');
%     dobot_sim.startSim(sync);
    
    i = 1;
    while (i < 4)
        %% Variables for testing vs submitting
        % Given that we are given the coordinates (Vison == False)
        %init_xy = [54.1, 410.8; 288.2, 127.7; 99.2, 80.3];
        
        %dest_xy = [273, 328; 145.6, 157.6; 93.7, 82.1];
        
        % For submission
        init_xy = init_positions;
        dest_xy = dest_positions;
        
        %% Execute Pick and Place
        
        % Declare the constants
        link1 = 138;
        link2 = 135;
        link3 = 147;
        link4 = 060;
        link5 = 075;
           
        % Given Coordinates
        X = init_xy(i,1);
        Y = init_xy(i,2);
        %Z = 138; 
        
        %To find the robot coodinates from the measured
        Xr = X - 80;
        Yr = Y - 290;
        
        %%-------------------------Reach Target-------------------------%%
                
        % This section iterates through each start and end coordinates
        % to pick up each object and place at the desired location
        %init_xy = init_positions;
        %dest_xy = dest_positions;
        
        % Theta 1
        theta1 = atan2d(Yr , Xr);
        
        % Hovering over the target
        ReachTarget = [theta1 0 0 0  0]
        % Robot does step 1       
        dobot_sim.setJointPositions(ReachTarget); 
        
        pause(4);
        
%         % Making sure the joints are reached all the time
%         while(1)
%             Current = dobot_sim.getJointPositions();
%             % Current(1)
%             if(Current(1) == ReachTarget(1)) % I'd say let's leave it like this, since its millimeters. 0.0.. won't really matter noh?
%                 break;
%             else
%                 dobot_sim.setJointPositions(ReachTarget);
%             end
%         end 
        
        %%------------------------Reach Cylinder------------------------%%
        % Height of implemented (Z) => Cylinder
        Z = 60; % Used for pick up
        
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
        
        % Reach cylinder
        ReachCylinder = [theta1 theta2 theta3 theta4 theta5]
        % Robot does step 2
        dobot_sim.setJointPositions(ReachCylinder);
        pause (4) 
        
        % Robot turns on suction
        dobot_sim.setSuctionCup(true);
        
        pause(4)
        %%------------------------Pick Cylinder-------------------------%%
        % Pick cylinder
        PickCylinder = [theta1 0 0 0 0]
        % Robot does step 2
        dobot_sim.setJointPositions(PickCylinder);
              
         
        
        pause(4);
        
        
        %%----------------------Reach Destination-----------------------%%
        % Implementing IK for the second time      
        % Move to new location function
        Xend = dest_xy(i,1);
        Yend = dest_xy(i,2);
        Zend = 60; %Used for drop down 
        
        Xr = Xend - 80;
        Yr = Yend - 290;
        
        % Theta 1        
        theta1 = atan2d(Yr , Xr);
        
        % Theta 3
        vertical = Z + link5 - link1;
        horizontal = sqrt(Xr^2 + Yr^2)  - link4;
        lengthB = sqrt(vertical^2 + horizontal^2);
        A = (link2^2 + link3^2 - lengthB^2) / (2 * link2 * link3);
        theta3 = 90 - atan2d(sqrt(1- A) , A);
        
        % Theta 2
        G = (link2^2 + lengthB^2 - link3^2)/(2*link2*lengthB);
        thetaB = atan2d(sqrt(1-G^2), G);
        thetaA = atan2d(vertical, horizontal);
        theta2 = 90 - (thetaA + thetaB);
        
        % Theta 4
        theta4 = -theta2 - theta3;
        
        % Hovering over the destination
        ReachDestination = [theta1 0 0 0 0]
        dobot_sim.setJointPositions(ReachDestination); 
        
        pause(10);
        
        %%------------------------Place Cylinder-------------------------%%
        
        
        % Drop down and place cylinder
        PlaceCylinder = [theta1 theta2 theta3 theta4 theta5]
        
        % Robot keep the cyclinder
        dobot_sim.setJointPositions(PlaceCylinder);
        
        pause(4);
        % Turn suction off
        dobot_sim.setSuctionCup(false);
        
        pause(2);
        %%--------------------------Finish Drop--------------------------%%
        
        % 
        FinishDrop = [theta1 0 0 0 0]
        
        dobot_sim.setJointPositions(FinishDrop);
        
        pause(4);
        
        
        
        
    
        
        i = i + 1;
        
    end
    
    
 end
%% Execute Pick and Place

        % This section iterates through each start and end coordinates
        % to pick up each object and place at the desired location
        
        X = 288e-3; Y = 452e-3; Z = 50e-3;
        %X = 20e-3; Y = 20e-3;
        % Declare the constants 
        link1 = 0.138;
        link2 = 0.135;
        link3 = 0.147;
        link4 = 0.060;
        link5 = 0.075;
        
        % Declare the variables 
        
        %To find the robot coodinates from the measured
        Xr = X - 80e-3;
        Yr = Y - 290e-3;
        % Code for executing the inverse kinematics
        
        %Theta 1
        theta1 = atan2d(Yr , Xr);
        
        %Theta 3
        vertical = Z + link5 - link1;
        horizontal = sqrt(Xr^2 + Yr^2)  - link4;
        lengthB = sqrt(vertical^2 + horizontal^2);
        A = (link2^2 + link3^2 - lengthB^2) / (2 * link2 * link3);
        theta3 = 90 - atan2d(sqrt(1- A) , A);
        
        %Theta 2
        %thetaB = asind(  (link3 *(sin(90 - theta3)))/lengthB) ; 
        G = (link2^2 + lengthB^2 - link3^2)/(2*link2*lengthB);
        thetaB = atan2d(sqrt(1-G^2), G);
        thetaA = atan2d(vertical, horizontal); %asind(  (sin(90) * Z + link5 - link1) / lengthB  );  
        theta2 = 90 - (thetaA + thetaB); 
        
        %Theta 4
        theta4 = -theta2 - theta3;
        
        %Theta 5
        theta5 = 0;
        
        target = [theta1 theta2 theta3 theta4 theta5]
        dobot_sim.setJointPositions(target);
        
        
        dobot_sim.setSuctionCup(true);
       
        %% Lift up 
        X = 288e-3; Y = 452e-3; Z = 150e-3;
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
        
        
        %% Move to new location function
        Xend = +2.7393e-01;
        Yend = +3.2834e-01;
        Zend = 150e-3;
        
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
        
        newtarget = [theta1 theta2 theta3 theta4 theta5]
        dobot_sim.setJointPositions(newtarget);
        %% Drop function
        dobot_sim.setSuctionCup(false);
        
        
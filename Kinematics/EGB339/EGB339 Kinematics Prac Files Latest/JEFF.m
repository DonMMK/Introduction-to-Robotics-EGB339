%% Solution for EGB339 prac for 2020




function [init_xy, dest_xy] = EGB339_prac_exam_group_11(dobot_sim, init_positions, dest_positions, use_vision)


  
    
    if use_vision == true
        
        
        % do computer vision on initial_positions and destination_positions arguments which are images
        
        % add your code here which should include move robot arm and capture image from sim %%
           
        % you will need to calculate the xy positions and return them at the end of this section of code
        % shapes_xy needs to be 
        % init_shape_xy and dest_xy need to be of size 3 x 2 and an example is shown below
        init_xy = [0,0; 0,0; 0,0];
        dest_xy = [0,0; 0,0; 0,0];
        
        
   else

        %% Execute Pick and Place

        % This section iterates through each start and end coordinates
        % to pick up each object and place at the desired location
   
    clear all
    sync = false;
    dobot_sim = coppeliaRobot('Dobot');
    dobot_sim.startSim(sync);
    % Coordinates
        init_positions = [93.7,82.1; 254.2,102.6; 66.6,399.8];
        dest_positions = [145.6,157.6;215,213.1; 288.3,452.2];
        
    % Constants
    L1=138;
    L2=135;
    L3=147;
    L4=60;
    L5=75;
    Zc=60+L5;
    
    % Getting the reference frame
    x = init_positions(1,1)-80+5;
    y = init_positions(1,2)-290;
    
    %%Move to initial position1 using IK
    q1=atan2d(y,x);
    r1=sqrt(x^2+y^2)-L4;
    r2=L1-Zc;
    R=sqrt(r1^2+r2^2);%Also equal to L2^2+L3^2-*cos(90-q3);
    M=(L2^2+L3^2-R^2)/(2*L2*L3);
    q3=90-atan2d(sqrt(1-M^2),M);
    N = (L2^2+R^2-L3^2)/(2*L2*R);
    alpha = atan2d(sqrt(1-N^2), N);
    beta=atan2d(r2,r1);
    omega=90-beta;
    q2=180-alpha-omega;
    q4=-q3-q2;
    target=[q1 q2 q3 q4 0]
    
    
    % robot moves
    dobot_sim.setJointPositions(target);
    pause(5);
    
    
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
    % Getting the image
    dobot_sim.setSuctionCup(true);
    dobot_sim.getImage();
    image=dobot_sim.getImage();
    figure();imshow(image)
    
    % Move by 5 degrees
    target=[q1 q2+5 q3 q4 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
    
    % Lifting
    target=[q1 0 0 0 0];
    dobot_sim.setJointPositions(target);
    
    pause(5);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
    
    
    
    %%Move to destination 1
    
    x = dest_positions(1,1)-80;
    y = dest_positions(1,2)-290;
    
    q1=atan2d(y,x);
    r1=sqrt(x^2+y^2)-L4;
    r2=L1-Zc;
    R=sqrt(r1^2+r2^2);
    M=(L2^2+L3^2-R^2)/(2*L2*L3);
    q3=90-atan2d(sqrt(1-M^2),M);
    N = (L2^2+R^2-L3^2)/(2*L2*R);
    alpha = atan2d(sqrt(1-N^2), N);
    beta=atan2d(r2,r1);
    omega=90-beta;
    q2=180-alpha-omega;
    q4=-q3-q2;
    target=[q1 q2 q3 q4 0];
    dobot_sim.setJointPositions(target);
    
    pause(5);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
            
    end
    dobot_sim.setSuctionCup(false);
    
    target=[0 0 0 q4 0];
    dobot_sim.setJointPositions(target);
%     Move to initial position 2
    x = init_positions(2,1)-80+29;
    y = init_positions(2,2)-290+23;
    
    q1=atan2d(y,x);
    r1=sqrt(x^2+y^2)-L4;
    r2=L1-Zc;
    R=sqrt(r1^2+r2^2);%Also equal to L2^2+L3^2-*cos(90-q3);
    M=(L2^2+L3^2-R^2)/(2*L2*L3);
    q3=90-atan2d(sqrt(1-M^2),M);
    N = (L2^2+R^2-L3^2)/(2*L2*R);
    alpha = atan2d(sqrt(1-N^2), N);
    beta=atan2d(r2,r1);
    omega=90-beta;
    q2=180-alpha-omega;
    q4=-q3-q2;
    target=[q1 q2 q3 q4 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
    dobot_sim.setSuctionCup(true);
       

    target=[q1 q2+5 q3 q4 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
    target=[q1 0 0 0 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
    %%Move to destination position2
    
    x = dest_positions(2,1)-80;
    y = dest_positions(2,2)-290;
    
    q1=atan2d(y,x);
    r1=sqrt(x^2+y^2)-L4;
    r2=L1-Zc;
    R=sqrt(r1^2+r2^2);
    M=(L2^2+L3^2-R^2)/(2*L2*L3);
    q3=90-atan2d(sqrt(1-M^2),M);
    N = (L2^2+R^2-L3^2)/(2*L2*R);
    alpha = atan2d(sqrt(1-N^2), N);
    beta=atan2d(r2,r1);
    omega=90-beta;
    q2=180-alpha-omega;
    q4=-q3-q2;
    target=[q1 q2 q3 q4 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
            
    end
    dobot_sim.setSuctionCup(false);
    
    target=[0 0 0 q4 0];
    dobot_sim.setJointPositions(target);
%     %%Move to initial position3
    x = init_positions(3,1)-80-10;
    y = init_positions(3,2)-290+15;
    
   
    q1=atan2d(y,x);
    r1=sqrt(x^2+y^2)-L4;
    r2=L1-Zc;
    R=sqrt(r1^2+r2^2);%Also equal to L2^2+L3^2-*cos(90-q3);
    M=(L2^2+L3^2-R^2)/(2*L2*L3);
    q3=90-atan2d(sqrt(1-M^2),M);
    N = (L2^2+R^2-L3^2)/(2*L2*R);
    alpha = atan2d(sqrt(1-N^2), N);
    beta=atan2d(r2,r1);
    omega=90-beta;
    q2=180-alpha-omega;
    q4=-q3-q2;
    target=[q1 q2 q3 q4 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
    dobot_sim.setSuctionCup(true);
       

    target=[q1 q2+5 q3 q4 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end
        target=[q1 0 0 0 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
         
    end

    %%Move to destination position3
    
    x = dest_positions(3,1)-80;
    y = dest_positions(3,2)-290;
    
    q1=atan2d(y,x);
    r1=sqrt(x^2+y^2)-L4;
    r2=L1-Zc;
    R=sqrt(r1^2+r2^2);
    M=(L2^2+L3^2-R^2)/(2*L2*L3);
    q3=90-atan2d(sqrt(1-M^2),M);
    N = (L2^2+R^2-L3^2)/(2*L2*R);
    alpha = atan2d(sqrt(1-N^2), N);
    beta=atan2d(r2,r1);
    omega=90-beta;
    sigma = 90-q3-alpha;
    q2=180-alpha-omega;
    q4=-q3-q2;
    target=[q1 q2 q3 q4 0];
    dobot_sim.setJointPositions(target);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
            
    end
    dobot_sim.setSuctionCup(false);
    while ((sum(abs(target)) > sum(abs(dobot_sim.getJointPositions()))+0.5) || (sum(abs(target)) < sum(abs(dobot_sim.getJointPositions()))-.5))
            
    end
    
    target=[0 0 0 q4 0];
    dobot_sim.setJointPositions(target);

%     
    



    

end
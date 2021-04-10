
% USAGE:
% In order to automate the marking we require this function template
% Please do not modify structure of this function but add your own code
% group_XX should also be changed to the number of your group
% The image_flag will indicate whether the init_positions & dest_positions argument is in the format 
% of an image or whether it has be called and xy (3 x 2 matrix) coordinates have been passed in

%function [init_xy, dest_xy] = EGB339_prac_exam_group_XX(init_positions, dest_positions, use_vision)

    
    %initializing
    close all; clear; clc
    sync = false;
    dobot_sim = coppeliaRobot('Dobot');
    dobot_sim.startSim(sync);
   
    use_vision = false;
   %% Homography
    % using images
    if use_vision == true
       
        init_img = imread('TestSheet1.jpg');
        dest_img = imread('TestSheet2.jpg');

        % do computer vision on initial_positions and destination_positions arguments which are images
           
        for i = 1:2
           
            if i == 1
                img = init_img;
            else
                img = dest_img;
            end
           
            img = im2gray(uint8(img));
            mask = imbinarize(img,'adaptive','ForegroundPolarity','dark','Sensitivity', 0.55); % imbinarize
           
            thresh = 100000; % threshold value
            mask = bwareaopen(mask, thresh); % threshold
            mask = ~mask; % invert
            s1 = regionprops('table', mask, 'Centroid', 'MajorAxisLength', 'MinorAxisLength'); % regionprops to find centroids
            centroids = cat(1, s1.Centroid); % identifying centroids
            s2 = regionprops('table', mask, 'Circularity', 'MajorAxisLength', 'MinorAxisLength'); % regioprops to find circularitry
            circularity = cat(1, s2.Circularity); % identifying circularity
           
            circ_val = 0.9; % circle circularity
            tri_val = 0.63; % triangle circularity
            sq_val1 = 0.63; % square circularity value 1
            sq_val2 = 0.87; % square circularity value 2
            circ = circularity > circ_val; % circle check
            tri = circularity < tri_val; % triangle check
            sq = (circularity < sq_val2) & (sq_val1 < circularity); % square check
           
            % circle centroids
            circ_centroids1 = centroids(:,1).* circ(:,1);
            circ_centroids1(circ_centroids1 == 0) = [];
            circ_centroids2 = centroids(:,2) .* circ(:,1);
            circ_centroids2(circ_centroids2 == 0) = [];
            if i == 1
                circles_init = [circ_centroids1, circ_centroids2];
            else
                circles_dest = [circ_centroids1, circ_centroids2];
            end
           
            % triangle centroids
            tri_centroids1 = centroids(:,1) .* tri(:,1);
            tri_centroids1(tri_centroids1 == 0) = [];
            tri_centroids2 = centroids(:,2) .* tri(:,1);
            tri_centroids2(tri_centroids2 == 0) = [];
            if i == 1
                tri_init = [tri_centroids1, tri_centroids2];
            else
                tri_dest = [tri_centroids1, tri_centroids2];
            end
           
            % square centroids
            sq_centroids1 = centroids(:,1) .* sq(:,1);
            sq_centroids1(sq_centroids1 == 0) = [];
            sq_centroids2 = centroids(:,2) .* sq(:,1);
            sq_centroids2(sq_centroids2 == 0) = [];
            if i == 1
                sq_init = [sq_centroids1, sq_centroids2];
            else
                sq_dest = [sq_centroids1, sq_centroids2];
            end
       
        end
        % add your code here which should include move robot arm and capture image from sim %%
           
        
        % you will need to calculate the xy positions and return them at the end of this section of code
        % shapes_xy needs to be 
        % init_shape_xy and dest_xy need to be of size 3 x 2 and an example is shown below
        init_xy = [0,0; 0,0; 0,0]; % multiply it by the transfomation 
        dest_xy = [0,0; 0,0; 0,0]; % 
        
    %If using vision the function will be called twice and on the second time will enter this section    
    else
        
%      %% Kinematics   
%         % init_positions and dest_positions are x,y coordinates
%         
%         % add your robot pick and place code here using init_positions and dest_positions%%
%         % 5 links
% %         thetai = zeros(1,5);
% %         di = zeros(1,5);
% %         alphai = zeros(1,5);
% %         ai = zeros(1,5);
%        
%         joints = dobot_sim.getJointPositions();
%        
%         thetai = [90, 30, 30, 0, 90];
%         di = [0.138, 0.135, 0.147, 0.06, 0.075];
%         alphai = [45, 45, 45, 45, 45];
%         ai = [1, 1, 1, 1, 1];
%        
%         % pose transformation matrix (using forward kinematics)
%         T = zeros(4,4,5);
%         TM = 1;
%        
%         for i = 1:5
%            
%             T(:,:,i) = [cosd(thetai(i)),  -sind(thetai(i)).*cosd(alphai(i)),  sind(thetai(i)).*sind(alphai(i)),   alphai(i).*cosd(thetai(i));
%                         sind(thetai(i)),  cosd(thetai(i)).*cosd(alphai(i)),   -cosd(thetai(i)).*sind(alphai(i)),  alphai(i).*sind(thetai(i));
%                         0,                sind(alphai(i)),                    cosd(alphai(i)),                    di(i);
%                         0,                0,                                  0,                                  1];
%                    
%             TM = TM * T(:,:,i);
% 
%         end
%        
%         disp(TM);
%        
%         % to get the joint variables (inverse kinematics)
%         xc = TM(1,4);
%         yc = TM(2,4);
%         zc = TM(3,4);
%        
%         var1 = (di(3)*sind(thetai(2)));
%         var2 = (di(3)*sind(thetai(2)));
%        
%         angcos1 = xc/var1;
%         angsin1 = yc/var2;
%        
%         % q1
%         if (var1 < 0)
%             angle1 = atan2d(-angsin1, -angcos1);
%             q1 = angle1 - 180;
%         elseif (var2 > 0)
%             angle1 = atan2d(angsin1, angcos1);
%             q1 = angle1 - 180;
%         else
%             disp(singular);
%         end
%        
%         % q2
%         var3 = sqrt(xc^2 + yc^2);
%        
%         zc_mod = di(1) - zc;
%        
%         if (var3 < 0)
%             angle2 = atan2d(zc_mod, -var3);
%             q2 = angle2 + 90;
%         elseif (var3 > 0)
%             angle2 = atan2d(zc_mod, var3);
%             q2 = angle2 + 90;
%         else
%             disp(singular);
%         end
%        
%         % q3
%         var4 = sqrt(xc^2 + yc^2 + zc_mod^2);
%        
%         q3  = var4 - 0.147; % harcoded
%        
%         
%         % motion
%         target = [q1 q2 q3 0 0];
%         dobot_sim.setJointPositions(target);
%         dobot_sim.getJointPositions();
%        
% 
%     end
   
    %image = dobot_sim.getImage;
    %imshow(image)
   
% end
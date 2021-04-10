
% USAGE:
% In order to automate the marking we require this function template
% Please do not modify structure of this function but add your own code
% group_XX should also be changed to the number of your group
% The image_flag will indicate whether the init_positions & dest_positions argument is in the format 
% of an image or whether it has be called and xy (3 x 2 matrix) coordinates have been passed in

function [init_xy, dest_xy] = EGB339_prac_exam_group_38(dobot_sim, init_positions, dest_positions, use_vision)
    
function [shapes] = classify_shapes(image)
        image = double(image)/255;
        R = image(:,:,1);
        G = image(:,:,2);
        B = image(:,:,3);
        intensity = R+G+B;
        
        imr = R./intensity;
        img = G./intensity;
        imb = B./intensity;
       
        binary_blue = imb>0.5;
        binary_red = imr>0.5;
        binary_green = img>0.5;
        
        stats = regionprops(binary_red, 'Centroid', 'Area', 'Circularity');
        centroids = cat(1, stats.Centroid);
        area = cat(1, stats.Area);
        circularity = cat(1, stats.Circularity);
        red_shapes = [centroids, area, circularity];
        red_shapes = num2cell(red_shapes);
        red_shapes(:,6) = {'Red'};
        
        stats = regionprops(binary_green, 'Centroid', 'Area', 'Circularity');
         centroids = cat(1, stats.Centroid);
        area = cat(1, stats.Area);
        circularity = cat(1, stats.Circularity);
        green_shapes = [centroids, area, circularity];
        green_shapes = num2cell(green_shapes);
        green_shapes(:,6) = {'Green'};
        
        shapes = [red_shapes; green_shapes];
        x = size(shapes,1);
        
        for i = 1:x
            if cellfun(@(x) x>=0.9, shapes(i,4))
                shapes(i,7) = {'Circle'};
                if cellfun(@(x) x>40000, shapes(i,3))
                    shapes(i,5) = {'Big'};
                else
                    shapes(i,5) = {'Small'};
                end                    
            elseif cellfun(@(x) x>=0.7, shapes(i,4))
                shapes(i,7) = {'Square'};
                 if cellfun(@(x) x>40000, shapes(i,3))
                    shapes(i,5) = {'Big'};
                else
                    shapes(i,5) = {'Small'};
                 end
            else
                shapes(i,7) = {'Triangle'};
                 if cellfun(@(x) x>25000, shapes(i,3))
                    shapes(i,5) = {'Big'};
                else
                    shapes(i,5) = {'Small'};
                end
            end
        end
    end
 
    if use_vision == true
        % do computer vision on initial_positions and destination_positions arguments which are images
        % add your code here which should include move robot arm and capture image from sim %%
        % angle of each joint
        target = [0 0 -45 45 0];
        dobot_sim.setJointPositions(target);
        pause(5);
        % take image of workspace
        image = dobot_sim.getImage();
        
        % Initial Position Details
              
        init_shapes = classify_shapes(init_positions);
        [~, order] = sort([init_shapes{:,1}], 'ascend');
        init_shapes = init_shapes(order,:);
        init_shapes(:,1:4) = [];
        
        % Destination Position Details
       
        dest_shapes = classify_shapes(dest_positions);
        [~, order] = sort([dest_shapes{:,1}], 'ascend');
        dest_shapes = dest_shapes(order,:);
        dest_shapes(:,1:4) = [];
        
        % image Homography to find coordinates
        
        % Calibration Marker Coordinates
        Q = [345, 560; 345, 290; 345, 20; 182.5, 560; 182.5, 290; 182.5, 20; 20, 560; 20, 290; 20, 20];
        Q = Q';
        
        % Find Calibration marker centroids
        image = double(image)/255;
        R = image(:,:,1);
        G = image(:,:,2);
        B = image(:,:,3);
        intensity = R+G+B;
        
        imr = R./intensity;
        img = G./intensity;
        imb = B./intensity;
        
        binary_blue = imb>0.5;
        binary_red = imr>0.5;
        binary_green = img>0.5;
  
        stats = regionprops(binary_blue, 'Centroid');
        centroids = cat(1,stats.Centroid); 
        
        [~, order] = sort(centroids(:,2),'descend');
        P = centroids(order,:);
        P = floor(P);
        P = sortrows(P,[2 1])';
        
        H = simple_homography(P,Q);
        
        % get rid of excess borders
        a = min(centroids)-20;
        b = max(centroids)+20;
        image(1:a(2),:) = 0;
        image(b(2):end,:) = 0;
        image(:,1:a(1),:) = 0;
        image(:,b(1):end,:) = 0;
       
        
        % classify shapes from the robot image
        shapes = classify_shapes(image); 
        x = size(shapes,1);
        
        for i = 1:x
            if cellfun(@(x) x>=0.9, shapes(i,4))
                shapes(i,7) = {'Circle'};
                if cellfun(@(x) x>2000, shapes(i,3))
                    shapes(i,5) = {'Big'};
                else
                    shapes(i,5) = {'Small'};
                end                    
            elseif cellfun(@(x) x>=0.7, shapes(i,4))
                shapes(i,7) = {'Square'};
                 if cellfun(@(x) x>1500, shapes(i,3))
                    shapes(i,5) = {'Big'};
                else
                    shapes(i,5) = {'Small'};
                 end
            else
                shapes(i,7) = {'Triangle'};
                 if cellfun(@(x) x>1000, shapes(i,3))
                    shapes(i,5) = {'Big'};
                else
                    shapes(i,5) = {'Small'};
                 end
            end
        end
       
        shapes(:,3:4) = [];
        
        % Use HOMOGRAPHY to find actual coordinates
        image_coords = shapes(:,1:2);
        image_coords = cell2mat(image_coords);
        image_coords(:,3) = 1;
        
        x = size(image_coords,1);
        
        for i = 1:x
            P1 = image_coords(i,:)';
            T1 = H*P1;
            T1 = T1(1:2)/T1(3);
            T1 = num2cell(T1);
            shapes(i,1:2) = T1;
        end
        
        % Find Initial Coordinates
        shape_class = shapes(:,3:5);
        a = size(shape_class,1);
        init_shapes = string(init_shapes);
        shape_class = string(shape_class);
        
        
        
        for i = 1:3
            for x = 1:a
                if init_shapes(i,:) == shape_class(x,:)
                    init_xy(i,:) = shapes(x,:);
                end
            end
        end

        init_xy(:,3:5) = [];
        init_xy = cell2mat(init_xy);
        
         % Find Destination Coordinates
        shape_class = shapes(:,3:5);
        a = size(shape_class,1);
        dest_shapes = string(dest_shapes);
        shape_class = string(shape_class);
        
        for i = 1:3
            for x = 1:a
                if dest_shapes(i,:) == shape_class(x,:)
                    dest_xy(i,:) = shapes(x,:);
                end
            end
        end

        dest_xy(:,3:5) = [];
        dest_xy = cell2mat(dest_xy);
        
    %If using vision the function will be called twice and on the second time will enter this section    
    else
        % init_positions and dest_positions are x,y coordinates
        % add your robot pick and place code here using init_positions and dest_positions%%
       L1 = 138;
       L2 = 135;
       L3 = 147;
       L4 = 60;
       L5 = 75;
       q1 = 0;
       q2 = 0;
       q3 = 0;
       q4 = 0;
       q5 = 0;
       init_target = zeros(3,5);
       init_travel = zeros(3,5);
       dest_target = zeros(3,5);
       dest_travel = zeros(3,5);
       Xr = 80;
       Yr = 290;
       Zr = 75;
       
       for i = 1:3
           X = init_positions(i,1)-Xr;
           Y = init_positions(i,2)-Yr;
           q1 = atan2d(Y,X);
           height = Zr + L5 - L1;
           length = sqrt(X^2+Y^2)-L4;
           a = sqrt(height^2 + length^2);
           b = (L2^2 + L3^2 - a^2)/(2*L2*L3);
           c = atan2d(sqrt(1-b^2), b);
           q3 = 90 - c;
           d = (L3^2 + a^2 - L2^2)/(2*L3*a);
           e = atan2d(sqrt(1-d^2), d);
           f = atan2d(height, length);
           q2 = 90 - e - f ;
           q4 = -q2 - q3;
           q5 = 0;
           
           init_target(i,:) = [q1 q2 q3 q4 q5];
           init_travel(i,:) = [q1 0 0 0 0];
       end
        
       for i = 1:3
           X = dest_positions(i,1)-Xr;
           Y = dest_positions(i,2)-Yr;
            q1 = atan2d(Y,X);
           height = Zr + L5 - L1;
           length = sqrt(X^2+Y^2)-L4;
           a = sqrt(height^2 + length^2);
           b = (L2^2 + L3^2 - a^2)/(2*L2*L3);
           c = atan2d(sqrt(1-b^2), b);
           q3 = 90 - c;
           d = (L3^2 + a^2 - L2^2)/(2*L3*a);
           e = atan2d(sqrt(1-d^2), d);
           f = atan2d(height, length);
           q2 = 90 - e - f ;
           q4 = -q2 - q3;
           q5 = 0;
           
           dest_target(i,:) = [q1 q2 q3 q4 q5];
           dest_travel(i,:) = [q1 0 0 0 0];
       end
     
       for i = 1:3
           
           current = dobot_sim.getJointPositions();
           
           target = init_travel(i,:);
           dobot_sim.setJointPositions(target);
           pause(10)
           
           target = init_target(i,:);
           dobot_sim.setSuctionCup(true);
           dobot_sim.setJointPositions(target);
           pause(5)
           
           target = init_travel(i,:);
           dobot_sim.setJointPositions(target);
           pause(5)

           target = dest_travel(i,:);
           dobot_sim.setJointPositions(target);
           pause(10)
           
           target = dest_target(i,:);
           dobot_sim.setJointPositions(target);
           pause(10)
           
           dobot_sim.setSuctionCup(false);
           
           target = dest_travel(i,:);
           dobot_sim.setJointPositions(target);

       end
    end
end
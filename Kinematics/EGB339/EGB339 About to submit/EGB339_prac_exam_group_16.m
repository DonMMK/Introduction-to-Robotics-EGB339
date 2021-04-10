function [init_xy, dest_xy] = EGB339_prac_exam_group_16(dobot_sim, init_positions, dest_positions, use_vision)


if use_vision == true
    
    % do computer vision on initial_positions and destination_positions arguments which are images
    % add your code here which should include move robot arm and capture image from sim %%
    % angle of each joint
    
    % at 45 degree camera angles, a good enough image of th workspace can be taken
    camangle = 45;
    dobot_sim.setJointPositions([0 0 -camangle camangle 0]);
    pause(5);
    
    % workspace image
    workspace = dobot_sim.getImage();
    
    % sorting positions initially
    % converting to binary image in rgb
    image = double(init_positions) / 255;
    
    % red channel of image
    R = image(:,:,1);
    
    % green channel of image
    G = image(:,:,2);
    
    % blue channel of image
    B = image(:,:,3);
    
    % combining
    intensity = R + G + B;
    
    % chromaticity of red, green and blue channels
    chromR = R ./ intensity;
    chromG = G ./ intensity;
    chromB = B ./ intensity;
    
    % binary imags of red, green and blue channels
    binaryR = chromR > 0.5;
    binaryG = chromG > 0.5;
    binaryB = chromB > 0.5; % not used
    
    % regionprops on red shapes
    redprops = regionprops(binaryR,  'Circularity', 'Centroid', 'Area');
    circularityR = cat(1, redprops.Circularity);
    centroidsR = cat(1, redprops.Centroid);
    areaR = cat(1, redprops.Area);
    shapesR = [centroidsR, areaR, circularityR];
    shapesR = num2cell(shapesR);
    shapesR(:,6) = {'Red'};
    
    % regionprops on green shapes
    greenprops = regionprops(binaryG, 'Circularity', 'Centroid', 'Area');
    circularityG = cat(1, greenprops.Circularity);
    centroidsG = cat(1, greenprops.Centroid);
    areaG = cat(1, greenprops.Area);
    shapesG = [centroidsG, areaG, circularityG];
    shapesG = num2cell(shapesG);
    shapesG(:,6) = {'Green'};
    
    % red and green shape properties
    shapesinit = [ shapesR;
        shapesG ];
    
    % size of shapesRG matrix
    sizeshapes = size(shapesinit, 1);
    
    % identification parameters
    circval = 0.9;
    sqval = 0.7;
    bigcircthresh = 40000;
    bigsqthresh = 40000;
    bigtrithresh = 25000;
    
    
    % for loop to classify tables of the shapes
    for i = 1:sizeshapes
        
        % circle identification
        if cellfun(@(sizeshapes) sizeshapes >= circval, shapesinit(i,4))
            shapesinit(i,7) = {'Circle'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigcircthresh, shapesinit(i,3))
                shapesinit(i,5) = {'Big'};
            else
                shapesinit(i,5) = {'Small'};
            end
            
            % square identification
        elseif cellfun(@(sizeshapes) sizeshapes >= sqval, shapesinit(i,4))
            shapesinit(i,7) = {'Square'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigsqthresh, shapesinit(i,3))
                shapesinit(i,5) = {'Big'};
            else
                shapesinit(i,5) = {'Small'};
            end
            
            % triangle identification
        else
            shapesinit(i,7) = {'Triangle'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigtrithresh, shapesinit(i,3))
                shapesinit(i,5) = {'Big'};
            else
                shapesinit(i,5) = {'Small'};
            end
        end
    end
    
    [~, order] = sort([shapesinit{:,1}], 'ascend');
    shapesinit = shapesinit(order,:);
    shapesinit(:,1:4) = [];
    
    % sorting positions of destination
    image = double(dest_positions) / 255;
    
    % red channel of image
    R = image(:,:,1);
    
    % green channel of image
    G = image(:,:,2);
    
    % blue channel of image
    B = image(:,:,3);
    
    % combining
    intensity = R + G + B;
    
    % chromaticity of red, green and blue channels
    chromR = R ./ intensity;
    chromG = G ./ intensity;
    chromB = B ./ intensity;
    
    % binary imags of red, green and blue channels
    binaryR = chromR > 0.5;
    binaryG = chromG > 0.5;
    binaryB = chromB > 0.5; % not used
    
    % regionprops on red shapes
    redprops = regionprops(binaryR,  'Circularity', 'Centroid', 'Area');
    circularityR = cat(1, redprops.Circularity);
    centroidsR = cat(1, redprops.Centroid);
    areaR = cat(1, redprops.Area);
    shapesR = [centroidsR, areaR, circularityR];
    shapesR = num2cell(shapesR);
    shapesR(:,6) = {'Red'};
    
    % regionprops on green shapes
    greenprops = regionprops(binaryG, 'Circularity', 'Centroid', 'Area');
    circularityG = cat(1, greenprops.Circularity);
    centroidsG = cat(1, greenprops.Centroid);
    areaG = cat(1, greenprops.Area);
    shapesG = [centroidsG, areaG, circularityG];
    shapesG = num2cell(shapesG);
    shapesG(:,6) = {'Green'};
    
    % red and green shape properties
    shapesdest = [ shapesR;
        shapesG ];
    
    % size of shapesRG matrix
    sizeshapes = size(shapesdest, 1);
    
    % identification parameters
    circval = 0.9;
    sqval = 0.7;
    bigcircthresh = 40000;
    bigsqthresh = 40000;
    bigtrithresh = 25000;
    
    
    % for loop to classify tables of the shapes
    for i = 1:sizeshapes
        
        % circle identification
        if cellfun(@(sizeshapes) sizeshapes >= circval, shapesdest(i,4))
            shapesdest(i,7) = {'Circle'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigcircthresh, shapesdest(i,3))
                shapesdest(i,5) = {'Big'};
            else
                shapesdest(i,5) = {'Small'};
            end
            
            % square identification
        elseif cellfun(@(sizeshapes) sizeshapes >= sqval, shapesdest(i,4))
            shapesdest(i,7) = {'Square'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigsqthresh, shapesdest(i,3))
                shapesdest(i,5) = {'Big'};
            else
                shapesdest(i,5) = {'Small'};
            end
            
            % triangle identification
        else
            shapesdest(i,7) = {'Triangle'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigtrithresh, shapesdest(i,3))
                shapesdest(i,5) = {'Big'};
            else
                shapesdest(i,5) = {'Small'};
            end
        end
    end
    
    [~, order] = sort([shapesdest{:,1}], 'ascend');
    shapesdest = shapesdest(order,:);
    shapesdest(:,1:4) = [];
    
    % coordinates of calibration markers
    Q = [345, 560; 345, 290; 345, 20; 182.5, 560; 182.5, 290; 182.5, 20; 20, 560; 20, 290; 20, 20];
    Q = Q';
    
    % converting to binary image in rgb
    workspace = double(workspace) / 255;
    
    % red channel of image
    R = workspace(:,:,1);
    
    % green channel of image
    G = workspace(:,:,2);
    
    % blue channel of image
    B = workspace(:,:,3);
    
    % combining
    intensity = R + G + B;
    
    % chromaticity of red, green and blue channels
    chromR = R ./ intensity;
    chromG = G ./ intensity;
    chromB = B ./ intensity;
    
    % binary imags of red, green and blue channels
    binaryR = chromR > 0.5;
    binaryG = chromG > 0.5;
    binaryB = chromB > 0.5; % not used
    
    % regionprops on blue shapes
    blueprops = regionprops(binaryB, 'Centroid');
    centroidsB = cat(1, blueprops.Centroid);
    
    % sorting the blue marker centroids
    [~, order] = sort(centroidsB(:,2),'descend');
    P = centroidsB(order,:);
    P = floor(P);
    P = sortrows(P,[2 1])';
    
    % calling form simple homography
    H = simple_homography(P,Q);
    
    % identifying the border lengths
    excess = 20;
    workspacemin = min(centroidsB) - excess;
    workspacemax = max(centroidsB) + excess;
    
    % removing the borders
    workspace(1:workspacemin(2),:) = 0;
    workspace(workspacemax(2):end,:) = 0;
    workspace(:,1:workspacemin(1),:) = 0;
    workspace(:,workspacemax(1):end,:) = 0;
    
    % getting shapes
    % converting to binary image in rgb
    image = double(workspace) / 255;
    
    % red channel of image
    R = image(:,:,1);
    
    % green channel of image
    G = image(:,:,2);
    
    % blue channel of image
    B = image(:,:,3);
    
    % combining
    intensity = R + G + B;
    
    % chromaticity of red, green and blue channels
    chromR = R ./ intensity;
    chromG = G ./ intensity;
    chromB = B ./ intensity;
    
    % binary imags of red, green and blue channels
    binaryR = chromR > 0.5;
    binaryG = chromG > 0.5;
    binaryB = chromB > 0.5; % not used
    
    % regionprops on red shapes
    redprops = regionprops(binaryR,  'Circularity', 'Centroid', 'Area');
    circularityR = cat(1, redprops.Circularity);
    centroidsR = cat(1, redprops.Centroid);
    areaR = cat(1, redprops.Area);
    shapesR = [centroidsR, areaR, circularityR];
    shapesR = num2cell(shapesR);
    shapesR(:,6) = {'Red'};
    
    % regionprops on green shapes
    greenprops = regionprops(binaryG, 'Circularity', 'Centroid', 'Area');
    circularityG = cat(1, greenprops.Circularity);
    centroidsG = cat(1, greenprops.Centroid);
    areaG = cat(1, greenprops.Area);
    shapesG = [centroidsG, areaG, circularityG];
    shapesG = num2cell(shapesG);
    shapesG(:,6) = {'Green'};
    
    % red and green shape properties
    shapesRG = [ shapesR;
        shapesG ];
    
    % size of shapesRG matrix
    sizeshapes = size(shapesRG, 1);
    
    % identification parameters
    circval = 0.9;
    sqval = 0.7;
    bigcircthresh = 40000;
    bigsqthresh = 40000;
    bigtrithresh = 25000;
    
    
    % for loop to classify tables of the shapes
    for i = 1:sizeshapes
        
        % circle identification
        if cellfun(@(sizeshapes) sizeshapes >= circval, shapesRG(i,4))
            shapesRG(i,7) = {'Circle'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigcircthresh, shapesRG(i,3))
                shapesRG(i,5) = {'Big'};
            else
                shapesRG(i,5) = {'Small'};
            end
            
            % square identification
        elseif cellfun(@(sizeshapes) sizeshapes >= sqval, shapesRG(i,4))
            shapesRG(i,7) = {'Square'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigsqthresh, shapesRG(i,3))
                shapesRG(i,5) = {'Big'};
            else
                shapesRG(i,5) = {'Small'};
            end
            
            % triangle identification
        else
            shapesRG(i,7) = {'Triangle'};
            
            if cellfun(@(sizeshapes) sizeshapes > bigtrithresh, shapesRG(i,3))
                shapesRG(i,5) = {'Big'};
            else
                shapesRG(i,5) = {'Small'};
            end
        end
    end
    
    sizeshapes = size(shapesRG, 1);
    
    % identification parameters
    circval = 0.9;
    sqval = 0.7;
    circthresh = 2000;
    sqthresh = 1500;
    trithresh = 1000;
    
    % for loop to classify tables of the shapes
    for i = 1:sizeshapes
        
        % circle identification
        if cellfun(@(sizeshapes) sizeshapes >= circval, shapesRG(i,4))
            shapesRG(i,7) = {'Circle'};
            
            if cellfun(@(sizeshapes) sizeshapes > circthresh, shapesRG(i,3))
                shapesRG(i,5) = {'Big'};
            else
                shapesRG(i,5) = {'Small'};
            end
            
            % square identification
        elseif cellfun(@(sizeshapes) sizeshapes >= sqval, shapesRG(i,4))
            shapesRG(i,7) = {'Square'};
            
            if cellfun(@(sizeshapes) sizeshapes > sqthresh, shapesRG(i,3))
                shapesRG(i,5) = {'Big'};
            else
                shapesRG(i,5) = {'Small'};
            end
            
            % triangle identification
        else
            shapesRG(i,7) = {'Triangle'};
            
            if cellfun(@(sizeshapes) sizeshapes > trithresh, shapesRG(i,3))
                shapesRG(i,5) = {'Big'};
            else
                shapesRG(i,5) = {'Small'};
            end
        end
    end
    
    shapesRG(:, 3:4) = [];
    
    % finding actual coordinates using homography
    coordinates = shapesRG(:, 1:2);
    coordinates = cell2mat(coordinates);
    coordinates(:,3) = 1;
    
    sizeshapes = size(coordinates, 1);
    
    for i = 1:sizeshapes
        coordinates_uv = coordinates(i,:)';
        coordinates_xy = H * coordinates_uv;
        coordinates_xy = coordinates_xy(1:2)/coordinates_xy(3);
        coordinates_xy = num2cell(coordinates_xy);
        shapesRG(i, 1:2) = coordinates_xy;
    end
    
    % initial coordinates
    shapes = shapesRG(:, 3:5);
    workspacemin = size(shapes, 1);
    shapesinit = string(shapesinit);
    shapes = string(shapes);
    
    for i = 1:3
        for sizeshapes = 1:workspacemin
            if shapesinit(i,:) == shapes(sizeshapes,:)
                init_xy(i,:) = shapesRG(sizeshapes,:);
            end
        end
    end
    
    init_xy(:, 3:5) = [];
    init_xy = cell2mat(init_xy);
    
    % destination coordinates
    shapes = shapesRG(:, 3:5);
    workspacemin = size(shapes, 1);
    shapesdest = string(shapesdest);
    shapes = string(shapes);
    
    for i = 1:3
        for sizeshapes = 1:workspacemin
            if shapesdest(i,:) == shapes(sizeshapes,:)
                dest_xy(i,:) = shapesRG(sizeshapes,:);
            end
        end
    end
    
    dest_xy(:, 3:5) = [];
    dest_xy = cell2mat(dest_xy);
    
else
    
    i = 1;
    while (i < 4)
        %% Variables for testing vs submitting
        
        % Given that we are given the coordinates (Vision == False)
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
        
        %%------------------------Reach Cylinder------------------------%%
        % Height of implemented (Z) => Cylinder
        Z = 60;
        
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
        Zend = 60; %
        
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
end

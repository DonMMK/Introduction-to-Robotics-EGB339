function validate_solution()
    % Use this function to validate your solution.
    % 
    % It iterates over all test images and calls your solution in line 18. 
    % Feel free to edit this function to help you debug and test your
    % solution!
        
    close all; clear all;  
         
    for i = 1:100
        % load the image (change the path if needed)
        img_filename = sprintf('test_images/test_%02d.png', i);
        img = imread(img_filename);          
        
        % load the true centroids (change the path if needed)
        data_filename = sprintf('test_images/test_%02d.mat', i);
        load(data_filename); true_centroids = centroid_markers;
        
        % ==================================================
        % >>>>>>>> CALL YOUR FUNCTION HERE <<<<<<<<
        [binary_img, centroids] = segment_blue_markers(img);
        % ==================================================
        
        % uncomment this for debugging / plotting
%         figure(); imshow(binary_img);
%         figure(); imshow(img);
%         hold on;
%         plot(centroids(:,1), centroids(:,2), 'r*')
%         plot(centroid_markers(:,1), centroid_markers(:,2), 'go');
%         hold off;
%         title(img_filename, 'interpreter', 'none');
%         pause(0.1);

        % did your script return too many centroids? There are only 9 true
        % centroids!
        if length(centroids) ~= 9
            fprintf('!!! Error in image %s! Too many centroids.\n', img_filename);               
        % compare your centroids with the true centroids
        elseif sum(ismembertol(true_centroids, centroids, 0.01, 'ByRows', true)) ~= 9
            fprintf('!!! Error in image %s. Wrong coordinates.\n', img_filename);            
        % all ok!
        else
            fprintf('Image %s correctly analysed.\n', img_filename);
        end
    end
    
    
end
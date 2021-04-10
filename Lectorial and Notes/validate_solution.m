function validate_solution()
    % Use this function to validate your solution.
    % 
    % It iterates over all test images and calls your solution. 
    % Feel free to edit this function to help you debug and test your
    % solution!
   
    close all; clear all;  
         
    for i = 1:100
        % load the image (change the path if needed)
        img_filename = sprintf('test_images/test_%02d.png', i);
        img = imread(img_filename);          
        
        % load the true centroids (change the path if needed)
        data_filename = sprintf('test_images/test_%02d.mat', i);
        load(data_filename); 
        
        % ==================================================
        % >>>>>>>> CALL YOUR FUNCTION HERE <<<<<<<<        
        [triangles, squares, circles, binary_img] = shapes(img);       
        % ==================================================

        % check if your solution is correct
        correct = true;

        if length(triangles) ~= 4
            fprintf('!!! Error in image %s. Incorrect number of triangles. \n', img_filename);
            correct = false;
        end

        if length(squares) ~= 4
            fprintf('!!! Error in image %s. Incorrect number of squares. \n', img_filename);
            correct = false;
        end

        if length(circles) ~= 4+9
            fprintf('!!! Error in image %s. Incorrect number of circles. \n', img_filename);
            correct = false;
        end

        true_centroids = centroid_squares;
        if sum(ismembertol(true_centroids, squares, 0.01, 'ByRows', true)) ~= 4
            fprintf('!!! Error in image %s. Square centroids do not match.\n', img_filename);
            correct = false;
        end

        true_centroids = centroid_triangles;
        if sum(ismembertol(true_centroids, triangles, 0.01, 'ByRows', true)) ~= 4
            fprintf('!!! Error in image %s. Triangle centroids do not match.\n', img_filename);
            correct = false;
        end

        true_centroids = [centroid_markers; centroid_circles];
        if sum(ismembertol(true_centroids, circles, 0.01, 'ByRows', true)) ~= 4+9
            fprintf('!!! Error in image %s. Circle centroids do not match.\n', img_filename);
            correct = false;
        end

        if correct == false
            figure; imshow(binary_img); hold on;
            plot(circles(:,1), circles(:,2), 'rx');
            plot(triangles(:,1), triangles(:,2), 'gx');
            plot(squares(:,1), squares(:,2), 'bx');    
            title(sprintf('%d', i));
            pause(0.1);
        end
    end               
end
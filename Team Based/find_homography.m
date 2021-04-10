%% My code 
function H = find_homography(filename)
    % Write a function that returns the Homography matrix as explained in the Problem description.
     
    % load the image
    img = imread(filename);
    
    % If you could not sovle Problem 2 (Segmentation of the Calibration Markers), 
    % you can call the get_centroids function below. However, this will cost you 2% of your marks.    
    % This function returns the centroids and areas (in pixels) for the blue markers. 
    % However, the ordering is arbitrary, i.e. the big circle is not guaranteed to be in position 1, etc.
    
    % [centroids, areas] = get_centroids(filename);
    
    
    
    
    % INSERT YOUR CODE HERE
    
    
    
    % store the image coordinates of the calibration marker centroids in the right order in P
    % P = [];
    
    % Using the same ordering, store the workspace coordinates of the calibration markers in Q.
    % Consult the problem description for coordinates.
    % You have to make sure that the coordinates in P and Q correspond to each other.
    % Q = [];
    
    % use the function simple_homography() to calculate the homography between two sets of points.    
    % H = simple_homography(P,Q);
    
%%%%%%%%Which camera%%%%%%%%%%%%%%%%
%Define the varibles
f0 = 0.0028;
u0 = 1288/2;
v0 = 728/2;
sigma = 4.08*(10^-6) ;
Z = 2; %Length from the camera to the matrix

% To get the camera matrix 

fmatrix  = [1/sigma 0 u0; 0 1/sigma v0; 0 0 1];
smatrix  = [f0 0 0 0    ; 0 f0 0 0    ; 0 0 1 0];
TopLeft  = [-1; -1; Z; 1];
TopRight = [ 1; -1; Z; 1];
BottRight= [1; 1; Z;  1];
BottLeft = [-1; 1; Z;  1];


C1 = fmatrix * smatrix * TopLeft;
C2 = fmatrix * smatrix * TopRight;
C4 = fmatrix * smatrix * BottRight;
C3 = fmatrix * smatrix * BottLeft;

C11 = C1./C1(3);
C12 = C2./C2(3);
C14 = C4./C4(3);
C13 = C3./C3(3);



X = [C11 C12 C14 C13];
X(3,:) = [];

%%%%%%Identifying blue markers%%%%%%%%%%%%%

% reading in the 2 color channels other than blue
R = img(:,:,1); % red
G = img(:,:,2); % green

% creating an image of blue
img = R + G;

% making the image logical but inverted
img = imbinarize(img);

% rows and columns
[rows, columns] = size(img);

% inverting the inverted image :)
for i = 1:rows
    for j = 1:columns
        if img(i, j) == 0
            img(i, j) = 1;
        else
            img(i, j) = 0;
        end
    end
end

% assigning to correct variable name
binary_img = img;

% regioprops to identify centroids of the blue shapes
s = regionprops(binary_img, 'Centroid');
centroids = [ 0 0 ];
s_counter = 1;

% for loop to store the centroids in a matrix
for i = 1:numel(s)
    centroids(i, 1) = s(s_counter).Centroid(1);
    centroids(i, 2) = s(s_counter).Centroid(2);
    s_counter = s_counter + 1;
    
    
end

%% Alt code


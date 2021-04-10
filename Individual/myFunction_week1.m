function filled = myFunction(img)
%Reset workspace
%clear all; close all; 
set(0,'DefaultFigureWindowStyle','docked');
% Your function will be called with img containing an opened image.
% 
% Determine whether the img shows an empty tote or not.
% Return 0 if the tote is empty, and 1 otherwise.   
% Hint: use the available example files: example_empty.jpg, example_empty2.jpg, example_filled.jpg, and example_filled2.jpg

  img_empty1 = imread('example_empty.jpg');
    % img_empty2 = imread('example_empty2.jpg');
    % img_filled1 = imread('example_filled.jpg');
    % img_filled2 = imread('example_filled2.jpg');

    % diff = abs(double(img_filled2) - double(img_empty1));
    diff = img - img_empty1;

    counter = 0;

    for i = 1:353
        for j = 1:640
            if diff(i, j) > 47
                counter = counter + 1;
            end
        end
    end

    if counter > 500
        filled = true;
    else
        filled = false;
    end


%Read/Load the two images
%img1 = imread('example_filled.jpg');
%img2 = imread('example_filled2.jpg');

%Display the images
%figure(); imshow(img1); title('Empty');
%figure(); imshow(img2); title('Empty2');


%Display the histograms
%figure();
%histogram(img1, 'BinLimits', [0,255], 'BinWidth',1);
%title('Histogram Empty'); xlabel('Value'); ylabel('Count');

%figure();
%histogram(img2, 'BinLimits', [0,255], 'BinWidth',1);
%title('Histogram Empty 2'); xlabel('Value'); ylabel('Count');

%img = imread('example_filled.jpg');
%figure();
%histogram(img, 'BinLimits', [0,255], 'BinWidth',1);

%object = img<50;
%figure(); imshow(object); title('Monadic');

%     Your function will be called with img containing an opened image.
%     img = imread('example_empty.jpg');
%     myFunction(img)
    
    % Determine whether the img shows an empty tote or not.
 %   [bincount] = histcounts(img, (0:255));
    
 %   null = 0;
    
   % for i = 1:255
   %     z = bincount(i);
    %    if z == 0
    %        null = null + 1;
    %    end
    %end
    
    % Return 0 if the tote is empty, and 1 otherwise.
    %if null > 10
   %     filled = false;
    %else
    %    filled = true;
    %end
    
    % Hint: use the available example files: example_empty.jpg, example_empty2.jpg, example_filled.jpg, and example_filled2.jpg
%axisHandle = gca;                         %handle to the axis that contains the histogram
%histHandle = axisHandle.Children;         %handle to the histogram
%histData = histHandle.Data;               %The first input to histogram()
%binEdges = histHandle.BinEdges;           %The second input to histogram() (bin edges)
% Reproduce the figure
%figure
%histogram(histData, binEdges)
% If you're looking for the height of each bar:
%barHeight = histHandle.Values; 

%object = imbinarize(img1, 50/255);
%object = imbinarize(img2, 200/255);
%figure; imshow(object)
    
%    Count = 0;
%for i = 1:
%    if 
%        for 
%        count = count + 1;
        
%    end
%end
%    if count > 20
%        filled = true;
%    else 
%        filled = false;
%    end 
    


% using double
%diff = double(img1)-double(img2);
%figure(); imshow(diff); title('with doubles');

%fprintf('\n\nwith doubles ... \n');
%fprintf('full: %d   empty: %d\n', img1(280,280),img2(280,280));
%fprintf('difference: %d\n', diff(280,280));

%fprintf('full: %d   empty: %d\n', img1(200,425),img2(200,425));
%fprintf('difference: %d\n', diff(200,425));


%If less pixels then return 0 else return 1 i.e filled


% load and display the original image
%img = imread('spatula.jpg');
%figure(); imshow(img); title('Original Image');

% show the histogram
%figure();
%histogram(img, 'BinLimits', [0,255], 'BinWidth',1); %Use BinLimits to get
%0-255 for grayscale images and each Bin is 1 width>> Brightness value
%histogram(img);
%title('Histogram'); xlabel('Value'); ylabel('Count');

% segment the image - spatula logical 1, background logical 0

% We can do that in different ways
% Simple monadic operation ...
%spatula = img<50;
%figure(); imshow(spatula); title('Monadic');
%
% ... or by using imbinarize
%spatula = imbinarize(img, 50/255);
%figure; imshow(spatula); title('Using imbinarize');


end
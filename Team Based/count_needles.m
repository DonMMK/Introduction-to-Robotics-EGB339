% function n = count_needles(img)
%     % Return the number of needles in the variable n
%     % img will be given as a uint8 grayscale image.
%     
%     n = 0;
% 
% end


function n = count_needles(img)

    
%% Convert Image to Greyscale
    img = rgb2gray(imread('needles_48.png'));
    %figure(); imshow(img);
  
%% Convert Image to Binary 
    mask = img - 145;
    mask = imbinarize(mask);
    mask = ~mask; %invert
    %figure(); imshow(mask);
    
%% Seperate inner circles
    mask2 = bwareaopen(mask, 10000);
    %figure(); imshow(mask2);
    
    inner = mask - mask2;
    %figure(); imshow(inner);
    
%% Label each section
    labeled = logical(inner);
    %unique(labeled)
    
%% Remove extra pixel errors and count
    needles = regionprops(labeled);
    errors = sum(cat(1, needles.Area) < 10);
    n = max(size(needles)) - errors;
    
end

%%
function n = count_needles(img)

    clc;

    img = rgb2gray(img);
  
    img = img - 255/2;
    
    img = imbinarize(img);
    
    img = 1 - img;
    
    filter = bwareaopen(img, 100000);
    
    holes = img - filter;
    
    count = logical(holes);

    points = regionprops(count);
    
    invalid = cat(1, points.Area);
    
    thresh = 10;
    
    invalid = sum(invalid < thresh);
    
    n = size(points);
    
    n = max(n);
    
    n = n - invalid;
    
end
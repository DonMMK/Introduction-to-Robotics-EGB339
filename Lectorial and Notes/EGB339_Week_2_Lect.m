clear all; close all; 
set(0,'DefaultFigureWindowStyle','docked');

%% load and display the original image
img = imread('spatula.jpg');
figure(); imshow(img); title('Original Image');

%% show the histogram
figure();
histogram(img, 'BinLimits', [0,255], 'BinWidth',1); %Use BinLimits to get
%0-255 for grayscale images and each Bin is 1 width>> Brightness value
%histogram(img);
title('Histogram'); xlabel('Value'); ylabel('Count');

%% segment the image - spatula logical 1, background logical 0

% We can do that in different ways
% Simple monadic operation ...
spatula = img<50;
figure(); imshow(spatula); title('Monadic');
%%
% ... or by using imbinarize
spatula = imbinarize(img, 50/255);
figure; imshow(spatula); title('Using imbinarize');

%% use logical operation to invert the mask
spatula = ~spatula;
figure; imshow(spatula); title('Inverted');

clear all; close all; 
set(0,'DefaultFigureWindowStyle','docked');

img1 = imread('full.jpg');
img2 = imread('empty.jpg');

figure(); imshow(img1); title('full');  
figure(); imshow(img2); title('empty');  

figure(1); hold on; plot(280,280,'ro'); plot(425,200,'go');
figure(2); hold on; plot(280,280,'ro'); plot(425,200,'go');

%% simple difference
diff = img1-img2;
figure(); imshow(diff); title('simple difference');

fprintf('full: %d   empty: %d\n', img1(280,280),img2(280,280));
fprintf('difference (incorrect method): %d\n', diff(280,280));

fprintf('full: %d   empty: %d\n', img1(200,425),img2(200,425));
fprintf('difference (incorrect method): %d\n', diff(200,425));


%% using double
diff = double(img1)-double(img2);
figure(); imshow(diff); title('with doubles');

fprintf('\n\nwith doubles ... \n');
fprintf('full: %d   empty: %d\n', img1(280,280),img2(280,280));
fprintf('difference: %d\n', diff(280,280));

fprintf('full: %d   empty: %d\n', img1(200,425),img2(200,425));
fprintf('difference: %d\n', diff(200,425));

%% double and abs()
diff = abs(double(img1)-double(img2));
figure(); imshow(diff); title('correct method');

fprintf('\n\ncorrect method ... \n');
fprintf('full: %d   empty: %d\n', img1(280,280),img2(280,280));
fprintf('difference: %d\n', diff(280,280));

fprintf('full: %d   empty: %d\n', img1(200,425),img2(200,425));
fprintf('difference: %d\n', diff(200,425));

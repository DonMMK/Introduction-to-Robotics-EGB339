%Restting script
close all; clear all; clc

%% Question 1
%Load the image 
image = imread('highway.jpg');

%Determine it's width and height
%originalImage = imread(fullFileName);
%[rows, columns, numberOfColorChannels] = size(originalImage);
whos image; %for more details of the image 
size(image) 

%% Question 2
%display the image 
imshow(image);
imtool(image) %interactive tool to examine pixels
max(max(image));
min(min(image));

%% Question 3
%Plotting pixel of column 1155
col_1155 = image(:,1155);
figure();
plot(col_1155);

%Plotting pixel row 1280
row_1280 = image(1280,:);
figure();
plot(row_1280)

%% Question 4
%creating smaller image of sign 
Traffic_sign = image(835:911 , 613:765);
figure();
imshow(Traffic_sign)

tiled = repmat(Traffic_sign,10,10);
imshow(tiled)

%% Question 5
%Making a copy of original image
image_copy = image;
image_copy(835:911 , 613:765) =200;
imshow(image_copy)

%% Question 6

%imageA = flipdim(image ,2);     %# horizontal flip
%imshow(imageA)
%imageB = flipdim(image ,1);     %# vertical flip
%imshow(imageB)

%horizontal flip
imageA = fliplr(image); 
imshow(imageA)

%vertical flip
imageB = flip(image);
imshow(imageB)

%negative image
imageC = 255 - image;
imshow(imageC)

%take every fourth pixel making the image resolution smaller
imageD = image(1:4:end, 1:4:end);
imshow(imageD)

%brighter image
imageE = image+100;
imshow(imageE)

%dimmer image
imageF = image-100;
imshow(imageF)

%
imageG = image/64;
imshow(imageG)

%% Question 7

image7 = im2double(image);
imshow(image7)

%% Question 8 
image8A = ones(10,10)*0.5;
imshow(image8A, 'InitialMagnification',2000)

image8B = image8A;
image8B(5:6, 5:6) = 0.9
imshow(image8B, 'InitialMagnification',2000)

[u,v] = meshgrid(1:10);
figure();
subplot(1,2,1)
imshow(u./10, 'InitialMagnification',2000)
title('u')
subplot(1,2,2)
imshow(v./10, 'InitialMagnification',2000)
title('v')

image8C = (u.^2 + v.^2)/200;
figure();
imshow(image8C, 'InitialMagnification',2000)


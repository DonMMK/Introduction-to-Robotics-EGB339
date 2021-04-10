clear all; close all; 
set(0,'DefaultFigureWindowStyle','docked');
%%

clear all; close all;

img = imread('highway_rgb.jpg');
imshow(img)

P = [607 1534; 953 1227; 1316 1222; 1598 1534]';
Q = [607 1534; 607 1227; 1598 1222; 1598 1534]';

H = simple_homography(P,Q);

view = imref2d(size(img));
img2 = imwarp(img, projective2d(H'), 'OutputView', view);

figure; imshow(img2);


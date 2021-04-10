%General Transform Matrix
close all; clear; clc

% Symbolic variables:  
syms theta1 theta2 theta3 theta4 theta5 theta6...  % angle about z axis
    d1 d2 d3 d4 d5 d6... % distance from joint about z axis
    a1 a2 a3 a4 a5 a6... % distance from join about x axis
    alpha1 alpha2 alpha3 alpha4 alpha5 alpha6... % angle about x axis
    L1 L2 L3 L4 L5 L6... % length of link (constant)
    q1 q2 q3 q4 q5 q6 % variables

% These are the variable parameters for each link. If you leave them
% commented, they will stay symbolic.
% Generally, setting them all to zero will be when the robot is at rest
% position.
% Make sure revolute joints are in degrees and prismatic joints are in
% meters

%q1 = 0;
%q2 = 0;
%q3 = 0;
% q4 = 0;
% q5 = 0;
% q6 = 0;

% % Uncomment if you want to have numerical link lengths rather than symbolic
% L1 = 2;
% L2 = 1.5;
% L3 = 3;
% L4 = 0;
% L5 = 0;
% L6 = 0;

% General Transform matrix for each link
% Only uncomment the amount of joints that are used in the robot.
% Inputs are (theta, d, a, alpha)

A1 = transforming(q1,0,0,0)
A2 = transforming(90,q2,0,90)
A3 = transforming(0,q3,0,0)
% A4 = transforming(q4,L4,a4,alpha4);
% A5 = transforming(q5,L5,a5,alpha5);
% A6 = transforming(q6,L6,a6,alpha6);

% Overall Transform Matrix
% Only uncomment Hx up to the highest Ax (for example, if you have 4
% joints you would have a maximum of A4, therefore you would need to
% uncomment H2,H3 and H4)

H2 = A1*A2;
H3 = H2*A3
% H4 = H3*A4;
% H5 = H4*A5;
% H6 = H5*A6;

% x,y,z positions in meters (x is on top, y is in the middle and z is on the bottom)
%set q1 - qx to 0 to find x and y at rest position 
disp('x,y,z of end effector:')
disp(H3(1:3,end))

                            
function [transform] = transforming(theta, d, a, alpha)
   transform =  [cosd(theta), -sind(theta)*cosd(alpha), sind(theta)*sind(alpha), a*cosd(theta);...
    sind(theta), cosd(theta)*cosd(alpha), -cosd(theta)*sind(alpha), a*sind(theta);...
    0, sind(alpha), cosd(alpha), d;
    0, 0, 0, 1];
end




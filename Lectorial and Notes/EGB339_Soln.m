%% Introduction to MATLAB
%{
    Unit: EGB339 - Introduction to Robotics
    Tutorial 0 Solution

    "Week 1 optional MATLAB Tutorial"
    
    Peter Corke
    3-September-2019 Lindsey Paul
%}

%% CLEARING THE WORKSPACE
clear all; close all; clc;

%% Desk Calculator (Implemented in MATLAB)
% The . is for element-wise operations as opposed to matrix operations, 
% in this example the dot isn't necessary but it's a good habit to get into
% to avoid issues in the future.

q1 = 2.^4
q2 = sqrt(7)
q3 = nthroot(20, 5)

% Note: trig functions used radians as default, either convert to rad or
% add d to the end of the function.
q4 = cos(deg2rad(20))
q4_alternate = cosd(20);

q5 = asin(deg2rad(0.1))

% sqrt(-1) is i, MATLAB will automatically use complex numbers.
q6 = sqrt(-1)
q7 = max([1, 2, 3])
q8 = abs(-7)

% Many functions print strings, the simplest is disp, but fprintf has more
% functionality.
disp('Hello World');
fprintf('Hello World\n'); % \n is like enter on the keyboard, new line
fprintf('I can print numbers in my text, such as %d and %f, how neat!\n', 5.4, 9.41);

% Rand returns a single uniformly distributed random number in the 
% interval (0,1).
q10 = rand(1)

% Note: you can save the current state of the random number generator and
% restore that state of the random number generator
s = rng;
rng(s);

q11 = 5;
fprintf('q11 is a variable, q11*4+1 = %d\n', q11*4+1);

p = [1 -2 -3]; % Quadratic: 1*x^2 -2*x - 3
q12 = roots(p) % Roots of the quadratic

% This will evaluate the expression and save it as ans. As soon as another 
% expression is evaluated without being stored as a variable, the
% value of ans will be replaced by the new answer. 
% Note: THIS IS NOT GOOD PRACTICE!
3+3;
q13 = ans

% Adding a suppressing colon, ;, stops the answer from printing in the
% console!

q14 = 1
q14 = 2;

%% Script Mode

a = 1;
b = 1;
c = 1;

r(1) = (-b + sqrt(b.^2 - 4.*a.*c))./(2.*a);
r(2) = (-b - sqrt(b.^2 - 4.*a.*c))./(2.*a);
    
if isreal(r) == false
    disp('Quadratic has no real roots')
end

fprintf('Quadratic has roots: %d, %d', r(1), r(2));

for i = 1:10
    fprintf('Number: %d, Square: %d\n', i, i.^2);
end

%% Function Mode

s = squared(5)
r = quadratic(a, b, c)

% NOTE: FUNCTIONS MUST BE AT THE END OF A FILE OR IN A SEPERATE SCRIPT!
% The functions used are located at the bottom of this script!

%% Vector and Matrix Mode
v1 = [1, 2; 3, 4]
v2 = v1+v1
v3 = inv(v2)
v4 = isequal(inv(v2), v2^(-1))
v5 = 1:10
v6 = v5+1
v7 = sqrt(v6)
v8 = linspace(0, 2*pi, 100)
v9 = sin(v8)

figure('name', 'v10')
plot(v8, v9, 'r-')
title('v10')
xlabel('v8 [Rad]')
ylabel('sin(v8)')

%% Functions
function x2 = squared(x)
    x2 = x.^2;
end

function r = quadratic(a, b, c)
    r(1) = (-b + sqrt(b.^2 - 4.*a.*c))./(2.*a);
    r(2) = (-b - sqrt(b.^2 - 4.*a.*c))./(2.*a);

    if isreal(r) == false
        disp('Quadratic has no real roots')
    end
end

%% END OF SOLUTION

% Please send suggestions for improvement of the tutorial solution 
% to the EGB339 teaching team at this email address: egb339@qut.edu.au
% Thank you!



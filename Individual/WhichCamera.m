
% Store the pixel coordinates of the projected corner points of the workspace in carthesian form in X.
% Make sure you carefully read the problem description and the instructions. Extract the necessary information from the linked resources.

% f0 = 0.0028; % focal length
% u0 = 644; % u-coordinate of image plane centre
% v0 = 364; % v-coordinate of image plane centre
% sigma = 10 * 10^-6; % physical pixel dimension, width and height
% C = [1/sigma 0 u0; 0 1/sigma v0; 0 0 1] * [f0 0 0 0; 0 f0 0 0; 0 0 1 0];
% x = 1;
% y = 1;
% z = 2;
% h = C * [x; y; z; 1];
% X = h2e(h);
% 
% function e = h2e(h)
% 
%     if isvector(h)
%         h = h(:);
%     end
%     e = h(1:end-1,:) ./ repmat(h(end,:), size(h,1)-1, 1);
% end

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


X5 = [C1 C2 C4 C3];
X = [C11 C12 C14 C13];
X(3,:) = []

function x = myFunction_homopart2(H, P)

%% YUP this code doenst work
 % Given Homography H (from image to work surface) and a point P on the work surface, calculate the image of P and return its carthesian coordinates as a 2-vector.
 
 
 % q = Hp;
 
% P () 
%  
%  % h2e function
%  
%     function e = h2e(h)
% 
%     if isvector(h)
%         h = h(:);
%     end
%     e = h(1:end-1,:) ./ repmat(h(end,:), size(h,1)-1, 1);
%     end
%  
%  x = [0; 0];

%% This maybe will

temp = (H^-1) * [P;1];

x = [temp(1)/temp(3);temp(2)/temp(3)];


end
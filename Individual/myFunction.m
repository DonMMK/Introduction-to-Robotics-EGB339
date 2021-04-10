 function fov = myFunction(f)
%     % f is the focal length and will be given in metres
%     
%     %1440 x 1080 pixels and 7mm diagonal sensor
%     %Accepts focal length f in meteres
%     %calc horizontal field of view in dgrees
% 
%     fov = 0;
%     
%     
% end
% 
% function [FOV_length, FOV_height, view_length, view_height] = camera_view(cam_length, cam_height, distance, focal_length)
% 
% % Function camera_view takes in the following inputs;
% %        cam_length - Lenght of camera sensor 
% %        cam_height - Height of camera sensor
% %        distance - Distance from camera to surface
% %        focal_length - Focal length of the camera
% %
% % and calculates the following outputs;
% %       FOV_length - The length-wise field of view angle
% %       FOV_height - The height-wise field of view angle
% %       view_length - The length of the image the camera can capture
% %       view_height - The height of the image the camera can capture
% 
% theta_length = (180/pi).*atan(cam_length./(2*focal_length));
% theta_height = (180/pi).*atan(cam_height./(2*focal_length));
% 
% FOV_length = 2 .* theta_length;
% FOV_height = 2 .* theta_height;
% 
% view_length = distance .* (cam_length./(2*focal_length));
% view_height = distance .* (cam_height./(2*focal_length));


% Pixels provided 

XPixels = 1440;
YPixels = 1080;

MagXY = sqrt(XPixels^2 + YPixels^2);

length = 1440/2;

PixelSize = 0.007/MagXY;

fov = 2*atan2d(length * PixelSize, f);

end
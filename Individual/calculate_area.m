function a = calculate_area(H)

%% Code that probably wont work
    % Given Homography H, return the area of the triangle with image vertices (640, 650), (590,800), and (540, 650)
    % H is defined from image coordinates to world coordinates.
   
    % triangle area = 0.5 * base * height;
   
%     height = max(H(2,:))  - min(H(2,:)); % - max(H(H ~= max(H(2,:), [], 'all')));
%    
%     base = max(H(1,:)) - min(H(1,:));

%     a = 0.5 * base * height;

%     x = H(1,:);
%    
%     y = H(2,:);
%    
%     for k = 1:length(H)
%         if H(3,k) ~= 0
%             x(:, k) = x(:, k) / H(3,k);
%             y(:, k) = y(:, k) / H(3,k);
%         end
%     end

%     if isvector(H)
%         H = H(:);
%     end
%    
%     e = H(1:end-1,:) ./ repmat(H(end,:), size(H,1)-1, 1);
%    
%     x = e(1,:);
%    
%     y = e(2,:);
% 
%     a = polyarea(x, y);
   

%% Code that will maybe...idk

% A 3x3 matrix with the points given
Points_Given = [ 640 650;
                 590 800;    
                 540 650]; 
    
% Giving the points in Homogenous form 
        %Using the code in lectorial to convert to homogenous??

Point1 = [640
          650;
            1];    
        
Point2 = [590
          800;
            1]; 
        
Point3 = [540
          650;
            1]; 
% Given the homography value H

area1 = (H^1)*Point1;
area2 = (H^1)*Point2;
area3 = (H^1)*Point3;

area1X = area1(1)/area1(3);
area2X = area2(1)/area2(3);
area3X = area3(1)/area3(3);

area1Y = area1(2)/area1(3);
area2Y = area2(2)/area2(3);
area3Y = area3(2)/area3(3);

X = [area1X area2X area3X];
Y = [area1Y area2Y area3Y];

%Area

a = polyarea(X, Y);

        
             
end

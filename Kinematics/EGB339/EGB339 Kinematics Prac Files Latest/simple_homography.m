%HOMOGRAPHY Estimate homography
%
% H = HOMOGRAPHY(P1, P2) is the homography (3x3) that relates two
% sets of 4 corresponding points P1 (2x4) and P2 (2x4) from two different
% camera views of a planar object.
%
% Notes::
% - The points must be corresponding, no outlier rejection is performed.
% - The points must be projections of points lying on a world plane
% %
% Author: Niko Suenderhauf
% Based on homography code by
% Peter Corke and Peter Kovesi

function [H] = simple_homography(p1, p2)

        if nargin < 2
            error('must pass uv1 and uv2');
        end
        
        if size(p1,2) ~= size(p2,2)
            error('must have same number of points in each set');
        end
        if size(p1,1) ~= size(p2,1)
            error('p1 and p2 must have same number of rows')
        end

        % linear estimation step
        H = vgg_H_from_x_lin(p1, p2);

end
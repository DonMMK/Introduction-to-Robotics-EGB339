function [triangles, squares, circles, mask] = shapes(img)

    mask = imbinarize(img,'adaptive','ForegroundPolarity','dark','Sensitivity', 1.1/2); % imbinarize
    
    thresh = 30000; % threshold value

    mask = bwareaopen(mask, thresh); % threshold

    mask = ~mask; % invert

    s1 = regionprops('table', mask, 'Centroid', 'MajorAxisLength', 'MinorAxisLength'); % regionprops to find centroids
    
    centroids = cat(1, s1.Centroid); % identifying centroids
    
    s2 = regionprops('table', mask, 'Circularity', 'MajorAxisLength', 'MinorAxisLength'); % regioprops to find circularitry
    
    circularity = cat(1, s2.Circularity); % identifying circularity
    
    circ_val = 0.9; % circle circularity
    
    tri_val = 0.63; % triangle circularity
    
    sq_val1 = 0.63; % square circularity value 1
    
    sq_val2 = 0.87; % square circularity value 2
    
    circ = circularity > circ_val; % circle check
    
    tri = circularity < tri_val; % triangle check
    
    sq = (circularity < sq_val2) & (sq_val1 < circularity); % square check
    
    % circle centroids

    circ_centroids1 = centroids(:,1).* circ(:,1); 
    
    circ_centroids1(circ_centroids1 == 0) = [];
    
    circ_centroids2 = centroids(:,2) .* circ(:,1);
    
    circ_centroids2(circ_centroids2 == 0) = [];
    
    circles = [circ_centroids1, circ_centroids2];
    
    % triangle centroids
    
    tri_centroids1 = centroids(:,1) .* tri(:,1);
    
    tri_centroids1(tri_centroids1 == 0) = [];
    
    tri_centroids2 = centroids(:,2) .* tri(:,1);
    
    tri_centroids2(tri_centroids2 == 0) = [];
    
    triangles = [tri_centroids1, tri_centroids2];
    
    % square centroids
    
    sq_centroids1 = centroids(:,1) .* sq(:,1);
    
    sq_centroids1(sq_centroids1 == 0) = [];
    
    sq_centroids2 = centroids(:,2) .* sq(:,1);
    
    sq_centroids2(sq_centroids2 == 0) = [];
    
    squares = [sq_centroids1, sq_centroids2];
 
end
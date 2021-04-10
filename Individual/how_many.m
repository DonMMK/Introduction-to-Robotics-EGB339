function n = how_many(img)
    
    b = imopen(img, ones(20, 20));
    s = regionprops(b, 'Area', 'BoundingBox');
    n = length(s);
end
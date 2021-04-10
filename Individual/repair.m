function repaired_img = repair(img)
% Your function will be called with img containing a //grayscale //uint8 image.

    %img = rgb2gray(img); %to make sure the image is grayscale
    
    %apply the medilt2 image
    
    repaired_image = medfilt2(img);
    repaired_img = repaired_image;


end

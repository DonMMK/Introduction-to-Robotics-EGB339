function count = coloured_objects(img)
    % Your function will be called with img being a RGB (3 channels) image of type double with values between 0 and 1.
    % You should return the variable count as a 3-vector.
    % count(1) should be the number of red objects, count(2) the number of green objects, count(3) the number of blue objects
    count = [0 0 0];
    

Red = img(:,:,1);
Green = img(:,:,2);
Blue = img(:,:,3);

intensity = Red + Green + Blue;

R = Red ./ intensity;
G = Green ./ intensity;
B = Blue ./ intensity;

        nums = 0;
        numRed = 0;
%Counting the number of red
for i = 1:size(R,1)
    for j = 1:length(R)
        if R(i, j) > 0.7
            nums = nums + 1;
        end
        if nums == 100
            numRed = numRed + 1;
            nums = 0;
        end
    end
end

        l = 0;
        numGreen = 0;
%Counting the number of green
for i = 1:size(G,1)
    for j = 1:length(G)
        if G(i, j) > 0.7
            l = l + 1;
        end
        if l == 100
            numGreen = numGreen + 1;
            l = 0;
        end
    end
end

        m = 0;
       numBlue = 0;
%Counting the number of blue
for i = 1:size(B,1)
    for j = 1:length(B)
        if B(i, j) > 0.7
            m = m + 1;
        end
        if m == 100
            numBlue = numBlue + 1;
            m = 0;
        end
    end
end
       count = [numRed numGreen numBlue];
  
    
end

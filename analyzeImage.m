function imagedata = analyzeImage(file_name, r, c) % r = horizontal slicing, c = vertical slicing

lineborderx = floor(7*(r/12)); % vertical border of investigated area (optional)
linebordery = floor(3*(c/4)); % horizontal border of investigated area (optional)

noisefactor = [14000; 40000]; % estimate of "noise" 1: on the area 2: outside the area 

image = imread(file_name); % read image file

image = imresize(original_image, 1/4); 
% imshow(image);          % for testing
[rows, cols, colorBands] = size(image); % measures of image and colorBands

subh = floor(rows/r); % subarea height (rounded towards zero)
subw = floor(cols/c); % subarea width (rounded towards zero)
subsize = subh*subw;

shadedata = zeros(1, 2); % shadedata: column 1: fragment occupied by the shade, column 2: outside fragment
areadata = zeros(2, 1); % row 1: fragment of shade in area, row 2: fragment not in area  
values = zeros(r, c); % values of gridded image will be placed here: value = amount of exposed floor in subimage
lineprob = 0;

grayim = mat2gray(image); % image to grayscale
[indim, cmap] = gray2ind(grayim, 64); % indexed image with colormap cmap of 64 gray shades

[thresholds, metric] = multithresh(indim, 3); % compute tone thresholds (amount = 3) and their effectiveness from indexed image

% -- you might want to consider compressing image before processing? --

for v = 1:r  % grid image and process each subimage
    for h = 1:c 
        startr = ((v-1)*subh)+1;                              % starting row
        endr = rows-(((r-v)*subh) + (rows-(r*subh)));         % next vertical border (= end row)
        startc = ((h-1)*subw)+1;                              % starting column
        endc = cols-(((c-h)*subw) + (cols-(c*subw)));         % next horizontal border (= end column)
        subim = indim(startr:endr, startc:endc);              % subarea to evaluate 

        % define amount of lighter gray in subimage 
        % sum pixels where color value is larger than the highest threshold 
        shadeamount = countShades(subim, thresholds(3));      % look for color values larger than 3rd threshold
        other = subsize-shadeamount;
        values(v, h) = shadeamount/subsize;                   % shaded pixels counted to matrix
        shadedata(1, 1) = shadedata(1, 1) + shadeamount;      % total amount of shade appended
        shadedata(1, 2) = shadedata(1, 2) + other;            % rest of pixels 
            if(v>lineborderx && h<linebordery)                % if linearea covered (modify border values or use parameters?!)
                areadata(1, 1) = areadata(1, 1) + other;      % append pixels to row 1 in areadata
            else                                              % else outside of area:
                areadata(2, 1) = areadata(2, 1) + other;      % append pixels to row 2 in areadata
            end 
    end
end

display(values);

area_estimate = areadata(1, 1) - noisefactor(1,1);
areaprob = area_estimate/shadedata(1, 1);               % probability of shade on area 
datapoint = values(:);                                  % reshape values matrix to a vector
imagedata = {datapoint, shadedata, areaprob, image}; 

%display(shadedata);
%display(areadata);
%display(areaprob);
end

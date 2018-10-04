
function centroidImages = processFolder(full_path, k, rows, columns) % full path of file containing dataset of images
    % k is number of clusters, rows and columns define gridding granularity

filenames = dir(fullfile(full_path, '*.png'));  % read all images with specified extention, its png in this case

n = numel(filenames);    			% count total number of photos (=datapoints) present in that folder

v_gr = rows;			  % divide photo to i.e. 5 areas vertically
h_gr = columns;			% divide photo to i.e. 10 areas horizontally
granularity = v_gr*h_gr;			      % gridding granularity
dataset = zeros(n, granularity);		% matrix for relevant info from images
                                    % rows = n = amount of datapoints, 
                    % columns = dimentionality of datapoints, depends on gridding granularity (5*10 =50)

images = cell(n, 2);				% initialise cell array for the images
image_no = 1:n;

for h = 1:n
    full_name = fullfile(full_path, filenames(h).name); % specify images' names with full path and extension   
    imagedata = analyzeImage(full_name, v_gr, h_gr);    % retrieve information of each image
	  datapoint = cell2mat(imagedata(1));       % first column in returned cellregion should contain values of the image
	  images(h, 1) = imagedata(4);    % store image to cell array
    images(h, 2) = imagedata(3);    % line probablility

	for i = 1:granularity			% iterate columns wich correspond to datapoints' dimentions
        coordinate =  datapoint(i);  
		    dataset(h, i) = coordinate; 	% save datapoints location in feature space
	end
end
 
centroids = getCentroids(dataset, k, granularity);  % get cluster centroids

centroidImages = sym([k, 2]);

for j = 1:k     % iterate centroids
    display(j);
		centroid = centroids(j);           % get the centroid image
        [ocurrence, index] = ismember(dataset, centroid);
        % find index if centroid is in dataset 
        for datasetIndex = 1:n
            if (ocurrence(datasetIndex)==1) % if ocurrence is true i.e. = 1
                display(datasetIndex);
                prob = cell2mat(images(datasetIndex, 2));       % areaprobability
                a_probability = double(prob);              % probability of pixels to be in the area
                centim = cell2mat(images(datasetIndex, 1)); % image
                centroidImages(j, 1) = datasetIndex;
                centroidImages(j, 2) = a_probability;
                imshow(centim);                   % show centroid image
                display(a_probability);           % show area-probability
                display(datasetIndex);
            end
        end
end 

display(centroidImages);

end

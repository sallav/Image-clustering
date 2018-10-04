function centroidset = getCentroids(dataset, k, dimentionality)

[cluster_indices, centroid_locations] = kmedoids(dataset, k);     
                                    % use k-means to cluster datapoints
                                    % centroid_locations gives coordinates
                                    % of centroids
                                    
centroidset = centroid_locations;

end

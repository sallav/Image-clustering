
function valuecount = countShades(data, threshold)

[values, last_occurence, indices] = unique(data); % unique values appearing in data matrix
valuecount = 0;                     % initialise valuecount to zero
amount = length(values);            % amount of values

counts = accumarray(indices(:), 1); % count how many times each value appears in data matrix

for i = 1:amount                    % iterate through values
    if (values(i)>=threshold)       % consider only values over or same as given threshold
        valuecount = valuecount + counts(i);    % accumulate overall count when large enough value encountered
    end
end

end


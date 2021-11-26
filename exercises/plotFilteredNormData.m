function plotFilteredNormData(data, min, max)
%plotFilteredNormData (data, min, max)
% Inputs:
% data - the 2 column array data storing the measurement and the age 
% min - the minimum age of measurements to be taken into account
% max - the maximum age of measurements to be taken into account
%
% This function is designed to plot the data for all persons aged between min and max.
% data is a 2 Column array with data(:,1) representing the measurement and data(:,2) representing the subjects age.
if nargin < 2
    min = -inf;
end
if nargin < 3
    max = inf;
end

relevantdata = [];
%first filter the data by creating a new variable to store the data
for i=1:size(data,1)
    %check it for every item in the data
	if data(i,2) > min && data(i,2) < max
		relevantdata(end+1,:) = data(i,:);
	end
end
%Get the values necessary for transferring the data to a range between 0 and 1
% i.e. obtain the minimum and maximum values.
% the data can then be converted to a 0-1 range by applying the following calulation
minimumval = min(relevantdata(:,1));
maximumval = max(relevantdata(:,1));
range = maximumval - minimumval;

%Convert the values to [0 ; 1]  by setting all values to (val - min) / range (i.e. transfer the minimum to 0 and divide by the range ) 
relevantdata(:,1) = (relevantdata(:,1) - minimumval)/range;

scatter(relevantdata(:,2),relevantdata(:,1));







function normData = getNormalisedExpression(FileName)
%normData = getNormalisedExpression(FileName)
% INPUT: 
% FileName - The FileName of an xls spreadsheet with the data
% OUTPUT:
% normData - The normalised Expression data
% 
% The function assumed that the last Gene (i.e. the last row of the numeric information) is a housekeeping gene
% It will normalise according to that gene and transform the data into a log2 scale.


[numeric,text,rawdata] = xlsread(FileName);
numeric = log2(numeric);

%Get the average of each time point
normData = [];
%normalize data based on the housekeeping gene
% i.e. divide each entry by the ratio of the measurements of the housekeeping gene 
% of that entry and the average housekeeping gene measurement
for timepoint = 1:size(numeric,2)
    normData(timepoint) = numeric(:,timepoint) / ( numeric(end,timepoint) / mean(numeric(end,:)));
end








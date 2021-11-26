function plotDemographics_Corrected_AllStates(DemographicsFile,Entry,Delimiter)
%plotDemographics_Example(DemographicsFile,Entry,Delimiter)
% DemographicsFile is a tabulatory file that contains information about some US demographics with a NAME column for the different states.
% Entry is the entry that should be mapped (its the String that is the header for this column). It has to contain numeric values.
% OPTIONAL:
% if the provided file is a csv file with non standard delimiters (e.g. tab ('\t')) provide them.


%Check how many arguments we have and assign the delimiter if it is
%specified
if nargin < 3
    tab = readtable(DemographicsFile);
else
    tab = readtable(DemographicsFile,'Delimiter',Delimiter);
end

reltab = tab(:,{'NAME',Entry});
%Load the matlab US representation
states = shaperead('usastatelo', 'UseGeoCoords', true);
names = {states.Name};
%initialise the data fields
vals = [];
minval = inf;
maxval = -inf;
%check all entries in the available Names and obtain the data 
for i = 1: numel(names)
    cname = names{i};
    %Make Exceptions for Hawai and Alaska, as we will plot them seperately
    if strcmp(cname,'Hawaii')
        indexHawaii = i;
        valHawaii = reltab{strcmp(cname,reltab{:,1}),2};
        if valHawaii > maxval
            maxval = valHawaii;
        end
        if valHawaii < minval
            minval = valHawaii;
        end
    elseif strcmp(cname,'Alaska')
        indexAlaska = i;
        valAlaska = reltab{strcmp(cname,reltab{:,1}),2}; 
        if valAlaska > maxval
            maxval = valAlaska;
        end
        if valAlaska < minval
            minval = valAlaska;
        end
    else
        %for anything else, get the respective value and store it.
        vals(end+1) = reltab{strcmp(cname,reltab{:,1}),2}; 
        if vals(end) > maxval
            maxval = vals(end);
        end
        if vals(end) < minval
            minval = vals(end);
        end
    end
end
%Get the colors (again special for Alaska and Hawaii)
hawaicolor = getColor(valHawaii,minval,maxval);
alaskacolor = getColor(valAlaska,minval,maxval);
colors = [];
for i=1:numel(vals)  
    color = getColor(vals(i),minval,maxval);
    colors(i,:) = color;
end

figure; 
%The axes are assigned to the "usamap" settings and hidden (otherwise its
%kind of ugly)
ax = usamap('all');
set(ax, 'Visible', 'off')

%get the indices of everything except alaska and hawaii
indexConus = 1:numel(names);
indexConus([indexHawaii, indexAlaska]) = []; 

%and assign the Specifications for the colors
faceColors = makesymbolspec('Polygon',...
     {'INDEX', [1 numel(names)-2], 'FaceColor', ...
      colors});

%and now show the states with the appropriate colors.
geoshow(ax(1), states(indexConus),  'SymbolSpec', faceColors)
geoshow(ax(2), states(indexAlaska), 'FaceColor', alaskacolor)
geoshow(ax(3), states(indexHawaii), 'FaceColor', hawaicolor)
for k = 1:3
    setm(ax(k), 'Frame', 'off', 'Grid', 'off',...
      'ParallelLabel', 'off', 'MeridianLabel', 'off')
end

%Make a title (essentially our original Entry identifier
title(Entry);
%and a legend representing the colormap
colormap hot;
colorbar('XTick',[0,1],'XTickLabel',{num2str(minval), num2str(maxval)});
end

function color = getColor(val,minval,maxval)
%Get the color and map the color range to the value range
%Returns a triplet indicating an RGB Color
entry = floor((val - minval )/ (maxval - minval) * 63)+1;
cs = hot;
color = cs(entry,:);
end

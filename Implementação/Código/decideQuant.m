function [ decision ] = decideQuant( input, dimension )
%decideQuant decides the value for the current area, given its dimension
%   This function is responsible for deciding whether the central pixel
%   belongs or not to the AOI

% global parameter;

% amountElements = parameter.quantDimension*parameter.quantDimension;
% amountElements = (parameter.quantDimension)^2;
amountElements = dimension^2;

input = reshape(input, [1 amountElements]);

counter = 1;
threshold = floor(amountElements/2);
nonAOI = 0;
isAOI = 0;

while counter <= amountElements && nonAOI <= threshold && isAOI < threshold
    if input(counter) == 0
        nonAOI = nonAOI + 1;
    else
        isAOI = isAOI + 1;
    end
    
    counter = counter + 1;
end

if nonAOI <= threshold
    decision = 1;
else
    decision = 0;
end

end
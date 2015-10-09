classdef Parameters
    %Parameters is the class responsible for global parameters
    %   Although global variables are not recomended, this class will make
    %   it easier to change parameters
    
    properties (Access = public, Constant = true)
        %% Code parameters
        diskFilterRadius = 70;
        thresholdPrecision = 0.00001;
        quantDimension = 5; %expected to be an odd value
        ILBPNeighborhoodDimension = 3; %expected to be an odd value
        
        %% Images to be displayed
        showOriginalImage = true;
        showBlurredImage = true;
        showRawAOIMask = false;
        showAOIMask = false;
        showAOI = true;
        
        %% Parallelism parameters
        useParallel = true;
        useSpecificPoolSize = true; % matlab uses a default number of pools
                                    % if it is not specified
        poolSize = 12;
    end
    
    methods
    end
    
end


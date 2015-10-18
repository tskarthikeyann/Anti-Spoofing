close all;
clear all;
clc;

%% Compiling C files
% compileCMEXFiles;
% 
% hello;

%% Loading parameters into global workspace
loadParameters;

global parameter;

%% Enabling parallel processing
if parameter.useParallel
    if parameter.useSpecificPoolSize
        p = gcp('nocreate');

        if ~isempty(p) && p.NumWorkers ~= parameter.poolSize
            delete(gcp);
            parpool('local', parameter.poolSize);
        elseif isempty(p)
            parpool('local', parameter.poolSize);
        end
    end
else
    p = gcp('nocreate');
    
    if ~isempty(p)
        delete(gcp);
    end
end

inputFolderRoot = 'input/';

textureDescriptorsFolderRoot = 'textureDescriptors/';

folderExists = 1;
initialFolderNumber = 19;
currentFolderNumber = initialFolderNumber - 1;
counter = 0;

while folderExists == 1
    currentFolderNumber = currentFolderNumber + 1;
    
    if exist(strcat(inputFolderRoot, num2str(currentFolderNumber)), 'dir') ~= 7
        folderExists = 0;
    else
        cd(strcat(inputFolderRoot, num2str(currentFolderNumber)));
        listing = dir('*.pgm');
        cd('../../');
        
        for i = 1:size(listing)
            filePath = strcat(inputFolderRoot, num2str(currentFolderNumber), '/', listing(i).name);
            fprintf('\n\n====================================================================================================\n');
            fprintf(strcat('Evaluating image: \0', filePath, '      Currently at-', num2str(i), '/', num2str(size(listing, 1)), ' image(s) on this folder.'));
            fprintf('\n====================================================================================================\n');
            
            %% Opening input image
            input = imread(filePath);

            %% Getting AOI mask
            aoiMask = getAOIMask(input);
            aoi = uint8(aoiMask).*input;

            %% Getting image's texture
            textureDescriptor = getTexture(aoi);
            
            %% Saving image's texture
            if exist(strcat(textureDescriptorsFolderRoot, num2str(currentFolderNumber), '/'), 'dir') ~= 7
                mkdir(strcat(textureDescriptorsFolderRoot, num2str(currentFolderNumber), '/'));
            end
            save(strcat(textureDescriptorsFolderRoot, num2str(currentFolderNumber), '/', strrep(listing(i).name, '.pgm', '.mat')), 'textureDescriptor');
            
        end
        
        counter = counter + size(listing, 1);
    end
end

fprintf('\n%d texture descriptor(s) generated!\n\nDone!\n', counter);
function [ inputDataSet, targetsSet ] = setDataSet()

textureDescriptorsFolderRoot = 'textureDescriptors/';
folders = dir('textureDescriptors\');
folders = folders(3:size(folders, 1));
foldersWithRealFingers = [1];
foldersWithObfuscatedFingers = [2 19];

inputDataSet = [];
targetsSet = [];
target = 0;

for i = 1:size(folders, 1)
    textureDescriptorsFiles = dir(strcat(textureDescriptorsFolderRoot, num2str(i), '/*.mat'));
    
    if any(i == foldersWithRealFingers) == 1
        target = 1;
    elseif any(i == foldersWithObfuscatedFingers) == 1
        target = 0;
    else
        target = -1;
    end
    
    for j = 1:size(textureDescriptorsFiles, 1)
        load(strcat(textureDescriptorsFolderRoot, num2str(i), '/', textureDescriptorsFiles(j).name));
        textureDescriptor = textureDescriptor';
        
        inputDataSet = [inputDataSet textureDescriptor];
        targetsSet = [targetsSet target];
    end
end

end
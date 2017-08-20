myFolder = '/Users/xiawei918/Documents/Baron_mat_converter/extra_instances/ScozzariTardella';
filePattern = fullfile(myFolder, '*.mat');
mpsFiles = dir(filePattern);

writeFolder = '/Users/xiawei918/Documents/Baron_mat_converter/extra_instances/ScozzariTardella_bar';
if ~exist(writeFolder,'dir')
    mkdir(writeFolder);
end

for k = 1:length(mpsFiles)
  baseFileName = mpsFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  barName = strcat(erase(baseFileName, '.mat'),'.bar');
  writeFileName = fullfile(writeFolder,barName);
  fprintf(1, 'converting file: %s to %s \n', baseFileName,writeFileName);
  
  convert_to_bar(fullFileName,writeFileName);
end


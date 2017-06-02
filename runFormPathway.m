%%%%%%%%%% Description %%%%%%%%%%%

% This script runs the formpathway on the videos provided in the 'Videos folder'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Set video folder. This folder contains videos for model input.
videofolder = 'Videos';

% check for the existence of the directory
folder = videofolder;
if 7 ~= exist(folder, 'dir')
    error([folder, ' is not a valid directory.'])
end

%% Run the properties script to initialize the model parameters
Properties;

%% 

if properties.isTraining
% Get the path to training images
    conditionList = getTrainingImagePath(properties);
else
% Read the videos and save them as the sequence of images. The model will
% take these images as the input.
    conditionList = storeAVIasPNGset(folder);
end
%% 
% The sequence of images are fed to the model and the output is a cell
% array 'formrespList'. Each element of this array is a structure, and, corresponds to each
% video. 
formrespList = cellfun(@(x) computeFormOutput(x,properties), conditionList, 'UniformOutput', false);



%% temporary script block
cat1size = size(formrespList{1,1}.v1f,4); 
cat2size = size(formrespList{1,2}.v1f,4); 

for i=1:cat1size
    t = formrespList{1,1}.l4resp{5,5}(:,:,:,i);
    arrresp(:,i) = t(:)-mean(t(:));
end
for i=1:cat2size
    t = formrespList{1,2}.l4resp{6,6}(:,:,:,i);
    arrresp(:,i+cat1size) = t(:)-mean(t(:));
end

X = arrresp';
y = [ones(cat1size,1);2*ones(cat2size,1)];
data = [X,y];

%% Run RBFN

runRBFN;


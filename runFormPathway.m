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

%% Read the videos and save them as the sequence of images. The model will
% take these images as the input.
conditionList = storeAVIasPNGset(folder);

%% The sequence of images are fed to the model and the output is a cell
% array 'formrespList'. Each element of this array is a structure, and, corresponds to each
% video. 
formrespList = cellfun(@(x) computeFormOutput(x,properties), conditionList, 'UniformOutput', false);



networkResp = RBF(respList);



videofolder = 'straight_traj_rect';

snapshotfolder = 'snapshot_test';

Properties;

%  testFormPathway( videofolder, snapshotfolder )
%          Test the Form pathway on video in 'videofolder'. Saves the 
%          result in 'snapshotfolder'. Uses 3 original filtering and 
%          pooling routines. All other routines are simply done to manage
%          the images(useful for debugging different stages of the model).
%
%                Version 1.0,  7 April 2016 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%




% % % 0.0 In the basic setting we just have the AVIs in 'videofolder'
% % % and specify the 'snapshotfolder' to save the network response
% % % (it will be created automatically with intermediate computations).

folder = videofolder;
if 7 ~= exist(folder, 'dir')
    error([folder, ' is not a valid directory.'])
end
    
% % % 1.1 Convert your videos to the images for easy debugging. If you know that
% % % you want a smaller number of images and/or snapshot neurons - its best
% % % to change it already inside this function to save time(e.g. save every
% % % 2nd frame).

conditionList = storeAVIasPNGset(folder);

% % % 1.2 Set the conditionList explicitly here as a cell array of string (full) 
% % % paths,if you don't want to call storeAVIasPNGset() each time. E.g.:

% conditionList = { 'video\0degree', 'video\30degree', 'video\45degree', 'video\60degree', 'video\90degree'};
% conditionList = { 'video_test\0degree_test', 'video_test\30degree_test'};
% conditionList = { '.\OrderedFrames'};

% % % 2.1 compute the form pathway responses. This saves the result automatically
% % % as 'formresp.mat' in same folder where the condition images are. The
% % % returned 'formrespList' also has all responses, however.

formrespList = cellfun(@(x) computeFormOutput(x), conditionList, 'UniformOutput', false);

% % % 2.2 Plot the responses if over the stimuli to debug the filters(if needed).
% % % But saving  over 50 900x900 images is very slow, only use to debug.

% cellfun(@(x) plotFormOutput(x), conditionList, 'UniformOutput', false);


% % % 3.1 This loads the the RBF responses from the disk for each condition. 
% % % It also saves the result as '_networkResp.mat' in the folder that you
% % % specify explicitly, e.g. 'sim'. '_networkResp.mat' is a structure with
% % % one file drepresenting the array of responses, and another field 
% % % representing the paths to the original conditions.

respList = cellfun(@(x) L4(x,properties),formrespList,'UniformOutput',false);


networkResp = RBF(respList);


% % % 3.2 Simply load and plot the snapshot population responses to each
% % % other, without saving anything. One snapshot population response
% % % represents the un-smoothed input to the dynamic layers of the model.
% % % One can load these responses directly and smooth them via ridge
% % % regression.

plotRBFProfiles(simulationFolder);



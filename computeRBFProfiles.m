function [networkResp] = computeRBFProfiles(varargin)
% computeRBFProfiles(varargin);
%          takes a list of folders containing form pathway output. Returns
%          a cell array where cell at (i, j) contains the RBF network 
%          response of population centered at pattern j to the input 
%          pattern at i. The last argument is the si
%
%          Meta-example:
%          We can call computeRBFvalues(folder1, folder2, simfolder)
%          
%          It'll retrieve V4 responses stored in 2 folders, e.g. r1 and r2.
%
%          Then it'll create two populations of RBF neurons corresponding 
%          to response patterns r1 and r2, where each neuron will be
%          centered on a single frame output, e.g. pop1 and pop2.
%          
%          Then calculate all possible responses of pop1 and pop2 to itself
%          and to each other. One response is one rectanguilar matrix.
%          
%          Then return a structure with a cell array of population of 
%          response combinations, and original pathkeys, e.g.

%          networkResp.resp = 
%          [pop1 to pop1] [pop2 to pop1]
%          [pop1 to pop2] [pop2 to pop2]
%          
%          networkResp.meta = [folder1, folder2]
%          
%          It will save the return result in simfolder.
%
%                Version 1.1,  7 April 2016 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%

% Don't hate me for this code. It's MATLAB cell arrays that suck.
% When I pass a cell array to the MATLAB function with varargin argument,
% it packs the whole cell array into another cell(this sucks). It forces
% to unpack it like varargin{1} before accessing original elements. For 
% example, in Python 2.7+ when you pass a list to the function, it does
% NOT pack it into another list.

stimulipaths = varargin{1}(1 : end - 1);%cell array of stimuli keys
simfolder = varargin{1}(end);%contents of the last cell is a char key
%Load a structure array of responses, where each response structure is derived from varargin
resplist = cellfun(@(x) loadPathwayResp(x), stimulipaths, 'UniformOutput', false); 


%From each structure element get V4 responses as a cell array
v4list = cellfun(@(x) x.('v4'), resplist, 'UniformOutput', false);
% Reshape V4 responses, so 3d response array to each image is a 1d array


% vecresp = cellfun(@(x) reshape(x, [size(x, 1) * size(x, 2) * size(x, 3), size(x, 4)]), v4list, 'UniformOutput', false);   

% To add shape detection
vecresp = cellfun(@(x) squeeze(max(reshape(x, [size(x, 1) * size(x, 2), size(x, 3), size(x, 4)]),[],1)), v4list, 'UniformOutput', false);   %  Nitin




rbf_scale = 0.05; %change this single parameter to change the RBF width

% Estimate to beta parameter of the RBF function
D = cell2mat(vecresp)' * cell2mat(vecresp);
beta = rbf_scale * 1.0 / sqrt(sum(D( : ) / size(D, 1) ^ 2));



% FLTCMP = 0.00000000001;


%Number of populations will equal the number of patterns
popnum = numel(vecresp); 

%This function will take a pair of indices as a single argument, and call 
%rbfOfColumns with predefined coefficient beta on two elements of v4resp
%that have these given indices.

rbfPatternResp = @(x) rbfOfColumns(beta, vecresp{ x(1) }, vecresp{ x(2) });

%supply pairs of indices to rbfPatternResp to call it on each pair
patternList = cellfun(rbfPatternResp, listPairs(1 : popnum), 'UniformOutput', false);

%an element at index (i,j) is the response of population j to pattern i
networkResp.resp = reshape(patternList, [popnum popnum]);
networkResp.meta = stimulipaths; % we save paths to know what paths were used for the network


%save the result
simpath = simfolder{1};
if ~exist(simpath, 'dir'), mkdir(simpath); end
save(fullfile(simpath, strcat('_networkResp', '.mat')),'networkResp')

%save the same result, but in an additional timestamped backup folder for
%potential future comparison
backuppath = 'now';
mkdir(simpath, backuppath);
save(fullfile(simpath, backuppath, strcat('_networkResp', '.mat')), 'networkResp');


return

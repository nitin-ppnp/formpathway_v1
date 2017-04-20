function plotRBFProfiles(folder, timestamp)
% plotRBFProfiles(folder, timestamp);
%          plots responses of the snapshot neuron level of the Giese-Poggio
%          2003 model to a given pathway input.
%
%                Version 1.1,  7 April 2016 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%

narginchk(1, 2)

if nargin == 1
    stimulipath = folder;
elseif nargin == 2
    stimulipath = fullfile(folder, timestamp);
end

respdata = load(fullfile(stimulipath, '_networkResp.mat'));
nresp = respdata.networkResp.resp;
keys = respdata.networkResp.meta;

%Recall that networResp.resp is a cell array where cell indexed i, j
%contains responses of population j to population i, e.g. for 2x2 array:
%          [pop1 to pop1] [pop2 to pop1]
%          [pop1 to pop2] [pop2 to pop2]
% Moreover, networkResp.meta stores a 1d cell array of pathkeys on which
% the populations were trained. So indexes i and j in .resp both correspond
% to index k from list 1:numel(keys). We use this identical numeration to
% label the plots.

[popnum,respnum] = size(nresp);
figure;
for rowind = 1 : popnum,
    for colind = 1:respnum,
        display((rowind-1)*popnum + colind)
        subplot(popnum, popnum, (rowind-1)*(popnum) + colind);
        surf(nresp{rowind, colind},'EdgeColor','none');
        view([-30,70])
        title(['Response of ', keys{colind}, ' to ', keys{rowind}])
    end
end

% display(1)

return


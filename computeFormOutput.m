function [formresp] = computeFormOutput(stimulipath)
% [formresp] = computeFormOutput(stimulipath);
%          computes responses of the form pathway of the Giese-Poggio 2003
%          model to the stimuli of large shaded walkers. Takes stimulipath as
%          an input - it should contain a list of PNGs representing the
%          relevant frames of the walker.
%                  
%                Based off unpublished code by Martin Giese written for his
%                PhD and subsequent early work. Review doi: 10.1038/nrn1057
%
%                Version 1.1,  07 April 2015 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%

narginchk(1,1)

PXM = loadPixelArray(stimulipath);

timeSize = size(PXM, 3)
% create the Gabor function array
GABA = mkgaba;


for k = 1:timeSize,
   [FV1f(:, :, :, k), FV1c(:, :, :, k),  xgct, ygct] = cgabmul(squeeze(PXM(:, :, k)), GABA);
end;



%         rectify, normalize and threshold
thrFV1f = 10;        % threshold
nmfFV1f = 70;        % fixed normalization factor
thrFV1c = 10;        % threshold   
nmfFV1c = 70;        % fixed normalization factor
FV1f = level(FV1f, thrFV1f, nmfFV1f);
FV1c = level(FV1c, thrFV1c, nmfFV1c);
% display(1)


%         CREATE THE V4 RESPONSES (BAR DETECTORS)

%         calculate the cell responses
for k = 1:timeSize,       % iterate over time steps
   [FV4bar(:, :, :, k), xcv4, ycv4] =  V1mr2V4rb(squeeze(FV1f(:, :, :, k)), ...
                     squeeze(FV1c(:, :, :, k)), xgct, ygct);
end;

thrV4b = 0.01;         % threshold
nmfFV4bar = 1;         % fixed normalization factor
FV4bar = level(FV4bar, thrV4b, nmfFV4bar);

formresp = struct('v1c',FV1c, 'v1f', FV1f, 'v4',FV4bar, 'v4pos', [xcv4; ycv4]);


save(fullfile(stimulipath, strcat('formresp','.mat')),'formresp')

% save for backup in a separate folder named as timestamp
savepath = strrep('now',':','-');
mkdir(stimulipath,savepath)
respath = fullfile(stimulipath, savepath, strcat('formresp','.mat'));
save(respath, 'formresp');


return


function [ resp ] = loadPathwayResp( folder )


dataname = 'formresp';
filename = 'formresp';

te = load(fullfile(folder, strcat(filename, '.mat')));
resp = te.(dataname);
clear te;

return

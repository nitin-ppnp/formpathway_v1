function [  ] = plotAnimacyResp(dirPath,tensor )
%PLOTANIMACYRESP Summary of this function goes here
%   Detailed explanation goes here

%
stimulipath = dirPath;

formdata = load(fullfile(stimulipath, 'formresp.mat'));
V4pos = [formdata.formresp.properties.rfmap.l3xct;formdata.formresp.properties.rfmap.l3yct];


neuron = formdata.formresp.properties.l3neuronToTrain;

listing = getFrameList(stimulipath);

O = marginalize(tensor,[4,6,7],'sum');
D = marginalize(tensor,[4,5,6],'sum');

figure;

for ind = 1:numel(listing)

[posX, posY] = meshgrid(V4pos(1, :), V4pos(2, :));


%%%%%%%%%%%%%%%%%%%%%%%
% % % t = squeeze(space(:,:,ind));
% % % [~,maxid] = max(t(:));
% % % [m1,m2] = ind2sub(size(t),maxid);
% % % 
% % % t = squeeze(velocity(:,:,ind));
% % % [~,maxid] = max(t(:));
% % % [m3,m4] = ind2sub(size(t),maxid);
% % % D = zeros(size(space,1),size(space,2),size(velocity,1));
% % % D(m1,m2,m3) = velocity(m3,m4,ind);
% % % 
% % % t = squeeze(shape(ind,m1,m2,:));
% % % [~,maxid] = max(t(:));
% % % [m3,m4] = ind2sub(size(t),maxid);
% % % O = zeros(size(space,1),size(space,2),size(shape,1));
% % % O(m1,m2,m4) = shape(m3,m4,ind); 

%%%%%%%%%%%%%%%%%%%%%%%
    
    
    img_in = im2double(imread(fullfile(stimulipath,listing{ind})));
    if size(img_in,3) > 1, img_in(:,:,2:3) = []; end
%     if ~isequal([fpos(3), fpos(4)], size(img_in))
%         set(f, 'position', [0 0 size(img_in)])
%     end
    imshow(img_in, 'Border', 'tight'); hold on;
    for i = 1:12
%         oneresp = V4(:, :, i, ind);
        oresp = 4*squeeze(O(ind,:, :, i));
        quiver(posX, posY, oresp*sin((i-1)*pi/6)*10, oresp*cos((i-1)*pi/6)*10, 0);
        dresp = 4*squeeze(D(ind,:, :, i));
        quiver(posX, posY, dresp*sin((i-1)*pi/6)*10, dresp*cos((i-1)*pi/6)*10, 0);      
    end

pause(0.05);
end


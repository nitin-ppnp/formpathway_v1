function [  ] = plotAnimacyResp(dirPath, orient, direc )
%PLOTANIMACYRESP Summary of this function goes here
%   Detailed explanation goes here

%
stimulipath = dirPath;

formdata = load(fullfile(stimulipath, 'formresp.mat'));
V4pos = [formdata.formresp.properties.rfmap.l3xct;formdata.formresp.properties.rfmap.l3yct];

nrows = size(orient, 1);
ncols = size(orient, 2);

neuron = formdata.formresp.properties.l3neuronToTrain;

listing = getFrameList(stimulipath);


figure;

for ind = 1:numel(listing)

[posX, posY] = meshgrid(V4pos(1, :), V4pos(2, :));


%%%%%%%%%%%%%%%%%%%%%%%
t = squeeze(direc(ind,:,:,:));
[~,maxid] = max(t(:));
[m1,m2,m3] = ind2sub(size(t),maxid);
D = zeros(size(orient,2),size(orient,3),size(orient,4));
% % for i1 = 1:size(V,1)
% %     for i2 = 1:size(V,2)
% %         V(i1,i2,maxid(i1,i2)) = orient(ind,i1,i2,maxid(i1,i2));
% %     end
% % end
D(m1,m2,m3) = orient(ind,m1,m2,m3);

t = squeeze(orient(ind,m1,m2,:));
[~,m3] = max(t);
O = zeros(size(orient,2),size(orient,3),size(orient,4));
% % for i1 = 1:size(V,1)
% %     for i2 = 1:size(V,2)
% %         V(i1,i2,maxid(i1,i2)) = orient(ind,i1,i2,maxid(i1,i2));
% %     end
% % end
O(m1,m2,m3) = orient(ind,m1,m2,m3); 

%%%%%%%%%%%%%%%%%%%%%%%
    
    
    img_in = im2double(imread(fullfile(stimulipath,listing{ind})));
    if size(img_in,3) > 1, img_in(:,:,2:3) = []; end
%     if ~isequal([fpos(3), fpos(4)], size(img_in))
%         set(f, 'position', [0 0 size(img_in)])
%     end
    imshow(img_in, 'Border', 'tight'); hold on;
    for i = 1:12
%         oneresp = V4(:, :, i, ind);
        oresp = 4*O(:, :, i);
        quiver(posX, posY, oresp*sin((i-1)*pi/6)*10, oresp*cos((i-1)*pi/6)*10, 0);
        dresp = 4*D(:, :, i);
        quiver(posX, posY, dresp*sin((i-1)*pi/6)*10, dresp*cos((i-1)*pi/6)*10, 0);      
    end


waitforbuttonpress;
end


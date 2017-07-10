dirPath = 'Videos/align';
out = classifierOP(dirPath);
% resp = Reich_det_new(dirPath);

% Get the indexes for maximum activity in x, y, speed, velocity direction 
for i=1:size(resp,1)
t = squeeze(resp(i,:,:,:,:));
% % t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% % [i1(i),i2(i)] = ind2sub(size(t),m);
% % direc(i,:) = t(i1(i),:);
% % vel(i,:) = t(:,i2(i))';
[x(i),y(i),velocity(i),vel_direc(i)] = ind2sub(size(t),m);
direc(i,:,:,:) = squeeze(t(:,:,velocity(i),:));
vel(i,:,:,:) = squeeze(t(:,:,:,vel_direc(i)));
end

% Get the maximum activity in shape and orientation domain, given the
% position of the object
for i=1:size(out,1)
t = squeeze(out(i,x(i),y(i),:,:));
% % t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% % [i1(i),i2(i)] = ind2sub(size(t),m);
% % orient(i,:) = t(i1(i),:);
% % shape(i,:) = t(:,i2(i))';
[shape(i),orientation(i)] = ind2sub(size(t),m);
orient(i,:) = squeeze(t(shape(i),:));
shp(i,:) = squeeze(t(:,orientation(i)));
end


%% Gaussian fitting to the max

orient = (orient-min(orient(:)))/(max(orient(:))-min(orient(:)));
direc = (direc-min(direc(:)))/(max(direc(:))-min(direc(:)));

gauss_ORIENT = fspecial('gaussian',[13,1],0.3);
gauss_ORIENT = gauss_ORIENT(1:end-1);
gauss_SHP = fspecial('gaussian',[3,1],0.5);
gauss_X = fspecial('gaussian',[25,1],0.5);
tensor = zeros(size(out,1),size(out,2),size(out,3),length(gauss_SHP),length(gauss_ORIENT),length(gauss_SHP),length(gauss_ORIENT));
for i=1:size(out,1)
    gauss_direc = circshift(gauss_ORIENT,[-6+vel_direc(i)-1,0]);
    gauss_orient = circshift(gauss_ORIENT,[-6+orientation(i)-1,0]);
    gauss_vel = circshift(gauss_SHP,[-1+velocity(i)-1,0]);
    gauss_shp = circshift(gauss_SHP,[-1+shape(i)-1,0]);
    gauss_y = circshift(gauss_X,[-12+y(i)-1,0]);
    gauss_y = gauss_y(1:18);
    gauss_x = circshift(gauss_X,[-12+x(i)-1,0]);
    gauss_x = gauss_x(1:18);
    space_mat = gauss_x*gauss_y';
    shape_mat = gauss_shp*gauss_orient';
    velocity_mat = gauss_vel*gauss_direc';
    t = space_mat(:)*shape_mat(:)';
    tensor(i,:,:,:,:,:,:) = reshape(t(:)*velocity_mat(:)',length(gauss_x),length(gauss_y),length(gauss_shp),length(gauss_orient),length(gauss_vel),length(gauss_direc));
end

plotAnimacyResp(dirPath,tensor);
%% Motion Energy and circular average

% % % e = exp(2*pi*1i*(0:size(orient,4)-1)/size(orient,4));
% % % or = reshape(reshape(orient,size(orient,1)*size(orient,2)*size(orient,3),size(orient,4)).*e,size(orient));
% % % or = sum(or,4);

% % % di = reshape(reshape(direc,size(direc,1)*size(direc,2)*size(direc,3),size(direc,4)).*e,size(direc));
% % % di = sum(di,4);
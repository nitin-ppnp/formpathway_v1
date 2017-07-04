dirPath = 'Videos/RotatingAgent';
out = classifierOP(dirPath);
resp = Reich_det_new(dirPath);

for i=1:size(resp,1)
t = squeeze(resp(i,:,:,:,:));
% % t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% % [i1(i),i2(i)] = ind2sub(size(t),m);
% % direc(i,:) = t(i1(i),:);
% % vel(i,:) = t(:,i2(i))';
[i1(i),i2(i),i3(i),i4(i)] = ind2sub(size(t),m);
direc(i,:,:,:) = squeeze(t(:,:,i3(i),:));
vel(i,:,:,:) = squeeze(t(:,:,:,i4(i)));
end

% figure;surf(direc)
for i=1:size(out,1)
t = squeeze(out(i,:,:,:,:));
% % t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% % [i1(i),i2(i)] = ind2sub(size(t),m);
% % orient(i,:) = t(i1(i),:);
% % shape(i,:) = t(:,i2(i))';
[i1(i),i2(i),i3(i),i4(i)] = ind2sub(size(t),m);
orient(i,:,:,:) = squeeze(t(:,:,i3(i),:));
shape(i,:,:,:) = squeeze(t(:,:,:,i4(i)));
end

% figure;surf(orient);

%% Artificial gaussian fitting to the max (not implemented now)

% % % orient = (orient-min(orient(:)))/(max(orient(:))-min(orient(:)));
% % % direc = (direc-min(direc(:)))/(max(direc(:))-min(direc(:)));
% % % 
% % % gauss = fspecial('gaussian',[71,1],1);
% % % gauss = circshift(gauss,[-35,0]);

%% Motion Energy and circular average

% % % e = exp(2*pi*1i*(0:size(orient,4)-1)/size(orient,4));
% % % or = reshape(reshape(orient,size(orient,1)*size(orient,2)*size(orient,3),size(orient,4)).*e,size(orient));
% % % or = sum(or,4);

di = reshape(reshape(direc,size(direc,1)*size(direc,2)*size(direc,3),size(direc,4)).*e,size(direc));
di = sum(di,4);
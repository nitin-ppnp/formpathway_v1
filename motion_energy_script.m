out

for i=1:size(resp,1)
t = squeeze(resp(i,:,:,:,:));
% t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% [i1(i),i2(i)] = ind2sub(size(t),m);
% direc(i,:) = t(i1(i),:);
% vel(i,:) = t(:,i2(i))';
[i1(i),i2(i),i3(i),i4(i)] = ind2sub(size(t),m);
direc(i,:) = squeeze(t(i1(i),i2(i),i3(i),:));
vel(i,:) = squeeze(t(i1(i),i2(i),:,i4(i)))';
end
surf(direc)
for i=1:size(out,1)
t = squeeze(out(i,:,:,:,:));
% % t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% % [i1(i),i2(i)] = ind2sub(size(t),m);
% % orient(i,:) = squeeze(i1(i),:));
% % shape(i,:) = squeeze(:,i2(i)))';
[i1(i),i2(i),i3(i),i4(i)] = ind2sub(size(t),m);
orient(i,:) = squeeze(t(i1(i),i2(i),i3(i),:));
shape(i,:) = squeeze(t(i1(i),i2(i),:,i4(i)))';
end


%%

for i=1:40
    or(i,:) = interp(orient(i,:),6);
    di(i,:) = interp(direc(i,:),9,3);
end

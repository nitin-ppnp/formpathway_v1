function [ resp_v,filt_tens, marg_tens] = Reich_det( tens, properties )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fsize = properties.reich.fSize;
% fdist = properties.reich.fDist;
reich_xct = properties.reich.xct;
reich_yct = properties.reich.yct;

sz = size(tens);
frame_skp = 1;
sz_resp = [sz(1),sz(2),sz(3),4,8];
sz_resp(1) = floor(sz_resp(1)/frame_skp);
resp_v = zeros(sz_resp);   % Right now only for 4 velocities and 8 directions

% Filter
reich_filt = fspecial('gaussian',[fsize,fsize],0.1);
reich_filt = reich_filt - 0.3;


filt_tens = zeros(sz_resp(1),sz_resp(2),sz_resp(3));
marg_tens = zeros(size(filt_tens));
t = 1;
for i=1:frame_skp:sz(1)
    
    temp_tens = squeeze(tens(i,:,:,:,:));
    
    % Marginalization
%     marg_tens = marginalize(tens,[4,5],'sum');
    [~,m] = max(temp_tens(:));
    [i1,i2,i3,i4,i5] = ind2sub(size(tens),m);
    marg_tens(t,:,:) = squeeze(temp_tens(:,:,i4,i5));
    
    
    
    % Filtering
    pad = squeeze(marg_tens(t,:,:));
    pad = padarray(pad,[(size(reich_filt,1)-1)/2,(size(reich_filt,1)-1)/2],'replicate');
    filt_tens(t,:,:) = filter2(reich_filt,pad,'valid');
    
    % Normalize
    temp_tens = filt_tens(t,:,:);
    mi = min(temp_tens(:));
    ma = max(temp_tens(:));
    filt_tens(t,:,:) = (temp_tens-mi)/(ma-mi);
    
    t = t+1;
end


t = 1;
for i=1:size(filt_tens)-1
    resp_v(t,1:end,:,1,1) = filt_tens(i,1:end,:).*filt_tens(i+1,1:end,:);
    for j=1:3 % velocities are 0,1,2,3
        % 0 degree
        resp_v(t,1:end-j,:,j+1,1) = filt_tens(i,1:end-j,:).*filt_tens(i+1,j+1:end,:);
        % 45 degree
        resp_v(t,1:end-j,1:end-j,j+1,2) = filt_tens(i,1:end-j,1:end-j).*filt_tens(i+1,j+1:end,j+1:end);
        % 90 degree
        resp_v(t,:,1:end-j,j+1,3) = filt_tens(i,:,1:end-j).*filt_tens(i+1,:,j+1:end);
        % 135 degree
        resp_v(t,j+1:end,1:end-j,j+1,4) = filt_tens(i,j+1:end,1:end-j).*filt_tens(i+1,1:end-j,j+1:end);
        % 180 degree
        resp_v(t,j+1:end,:,j+1,5) = filt_tens(i,j+1:end,:).*filt_tens(i+1,1:end-j,:);
        % 225 degree
        resp_v(t,j+1:end,j+1:end,j+1,6) = filt_tens(i,j+1:end,j+1:end).*filt_tens(i+1,1:end-j,1:end-j);
        % 270 degree
        resp_v(t,:,j+1:end,j+1,7) = filt_tens(i,:,j+1:end).*filt_tens(i+1,:,j+1:end);
        % 315 degree
        resp_v(t,1:end-j,j+1:end,j+1,8) = filt_tens(i,1:end-j,j+1:end).*filt_tens(i+1,j+1:end,1:end-j);
    end
    t = t+1;
end
% Normalize
% mi = min(resp_v(:));
% ma = max(resp_v(:));
% resp_v = (resp_v-mi)/(ma-mi);
end


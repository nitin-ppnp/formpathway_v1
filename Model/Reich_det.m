function [ resp_v ] = Reich_det( tens, properties )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fsize = properties.reich.fSize;
% fdist = properties.reich.fDist;
reich_xct = properties.reich.xct;
reich_yct = properties.reich.yct;

sz = size(tens);
reich_filt = fspecial('gaussian',[fsize,fsize],0.5);
% reich_filt = mexihat(-(fsize-1)/2,-(fsize-1)/2,fsize);
marg_tens = marginalize(tens,[4,5],'sum');
% filt_tens = zeros(sz(1),length(reich_xct),length(reich_yct));
filt_tens = zeros(size(marg_tens));



% % for i=1:sz(1)
% %     filtstrty = 1;
% %     for j=1:size(filt_tens,2)
% %         filtstrtx = 1;
% %         for k=1:size(filt_tens,3)
% %             filt_tens(i,j,k) = sum(sum(squeeze(marg_tens(i,filtstrtx:filtstrtx+fsize-1,filtstrty:filtstrty+fsize-1)).*reich_filt));
% %             filtstrtx = filtstrtx + fdist;
% %         end
% %         filtstrty = filtstrty + fdist;
% %     end
% % end

for i=1:sz(1)
    filt_tens(i,:,:) = filter2(reich_filt,squeeze(marg_tens(i,:,:)));
end

sz_resp = [size(filt_tens),4,8];
resp_v = zeros(sz_resp);   % Right now only for 4 velocities and 8 directions


for i=1:sz(1)-1
    for j=0:3 % velocities are 0,1,2,3
        % 0 degree
        resp_v(i,1:end-j,:,j+1,1) = filt_tens(i,1:end-j,:).*filt_tens(i+1,j+1:end,:);
        % 45 degree
        resp_v(i,1:end-j,1:end-j,j+1,2) = filt_tens(i,1:end-j,1:end-j).*filt_tens(i+1,j+1:end,j+1:end);
        % 90 degree
        resp_v(i,:,1:end-j,j+1,3) = filt_tens(i,:,1:end-j).*filt_tens(i+1,:,j+1:end);
        % 135 degree
        resp_v(i,j+1:end,1:end-j,j+1,4) = filt_tens(i,j+1:end,1:end-j).*filt_tens(i+1,1:end-j,j+1:end);
        % 180 degree
        resp_v(i,j+1:end,:,j+1,5) = filt_tens(i,j+1:end,:).*filt_tens(i+1,1:end-j,:);
        % 225 degree
        resp_v(i,j+1:end,j+1:end,j+1,6) = filt_tens(i,j+1:end,j+1:end).*filt_tens(i+1,1:end-j,1:end-j);
        % 270 degree
        resp_v(i,:,j+1:end,j+1,7) = filt_tens(i,:,j+1:end).*filt_tens(i+1,:,j+1:end);
        % 315 degree
        resp_v(i,1:end-j,j+1:end,j+1,8) = filt_tens(i,1:end-j,j+1:end).*filt_tens(i+1,j+1:end,1:end-j);
    end
end

mi = min(resp_v(:));
ma = max(resp_v(:));
resp_v = (resp_v-mi)/(ma-mi);
end


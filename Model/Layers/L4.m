function [ l4Resp ] = L4( v4resp, properties )
%FOURTHLAYER Summary of this function goes here
%   Detailed explanation goes here

fSize = properties.l4.fSize;
fDist = properties.l4.fDist;
fDim = size(v4resp);

xct = ceil(fSize/2):fDist+1:fDim(2)-ceil(fSize/2);
yct = ceil(fSize/2):fDist+1:fDim(1)-ceil(fSize/2);

nRecField = length(xct);
l4Resp = cell(nRecField,nRecField);

for i = 1:length(xct)
    for j=1:length(yct)
        idxx = xct(i)-fDist:xct(i)+fDist;
        idxy = yct(i)-fDist:yct(i)+fDist;
        l4Resp{i,j} = v4resp(idxx,idxy,:,:);
    end
end


end


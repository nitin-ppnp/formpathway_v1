function [ rbfval ] = rbfcolumns( beta, arr1,arr2 )
%RBFCOLUMNS Summary of this function goes here
%   Detailed explanation goes here
[m,n] = size(arr1);
[k,l] = size(arr2);

if ( m ~= k)
    disp('Dimensions of column vectors in input arrays are not equal.');
else
    
diff = zeros(m,n,l);
    
for i=1:l
    diff(:,:,i) = arr1-arr2(:,i);
end
    
diff = squeeze(sum(diff.*diff,1));

rbfval = exp(-beta.*diff);

end


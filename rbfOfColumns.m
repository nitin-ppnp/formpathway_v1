function [rbfmatrix] = rbfOfColumns(beta, array1, array2)
% computeRBFvalues(beta, array1, array2);
%          % Computes the values of the RBF function between each pair of
%          columns taken from  array1 and array2, given the beta parameter.
%          Element (i,j) contains RBF value given i-th column of array1 and 
%          j-th column of array2.
%
%                Version 1.1,  21 October 2015 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%
% one column of array 1 is a center vector of one RBF
% one column of array 2 is an input vector to one RBF

[m,n] = size(array1);
[k,l] = size(array2);

if ( m ~= k)
    display(['Dimensions of column vectors in input arrays are not equal.']);
else
    

    % centers is array1 replicated to have size[m*l n]
    centers = repmat(array1, [l 1]);
    % inputs is array 2 reshaped to become a single column
    inputs = reshape(array2, [k*l 1]);

    % compute column diffs of each pair of column vectors a single call
    diffs = bsxfun(@minus, centers, inputs);    
    
    % compute squared l2 norm of each difference of columns; to do that
    % we reshape diffs to a single row of column vectors beforehand
    sqrdDists = sum(reshape(diffs, [m l*n]).^2, 1);
    
    % get rbf values on a single row vector
    rbfvalues = exp( -beta.* sqrdDists);
    
    % returns a matrix where rows are indexed after array1 columns 
    % and columns are indexed after array2 columns
    rbfmatrix = reshape(rbfvalues, [n l]);
end

return
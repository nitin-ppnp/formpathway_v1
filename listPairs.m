function [pairs] = listPairs(index, varargin)
% listPairs(index, varargin);
%          Returns a Cartesian product of a list of integer indices with
%          itself. First argument should be a 1-dimensional vector of
%          numbers. If the second argument is 'num', returns a 2d array
%          with rows as product elements. If its empty, returns a cell
%          array with cells as product elements. 'Lists' allow repetitions.
%          Example:
%          >>te = 1:2.5:8
%
%          te =
%              1.0000    3.5000    6.0000
% 
%          >>listPairs(te, 'num')
%
%          ans =
% 
%               1.0000    1.0000
%               3.5000    1.0000
%               6.0000    1.0000
%               1.0000    3.5000
%               3.5000    3.5000
%               6.0000    3.5000
%               1.0000    6.0000
%               3.5000    6.0000
%               6.0000    6.0000
%
%                Version 1.0,  22 October 2015 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%
pairs = [];

indices = combvec(index, index)';

if numel(varargin) == 0 
    pairs = mat2cell(indices, ones(1, numel(index)^2), 2);
elseif numel(varargin) == 1 && isequal(varargin{1}, 'num')
    pairs = indices;
end

return
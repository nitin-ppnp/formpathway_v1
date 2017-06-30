function [ out_tens ] = marginalize( tensor, dim, type )
%MARGINALIZE returns the marginalized tensor

sz = size(tensor);
rem_dim = 1:length(sz);
rem_dim(dim)=[];
newsz = sz;
newsz(dim) = [];
if type == 'sum'
    out_tens = squeeze(sum(reshape(permute(tensor,[dim,rem_dim]),[prod(sz(dim)),newsz])));
elseif type == 'max'
    %     out_tens = squeeze(max(reshape(permute(tensor,[dim,rem_dim]),[prod(sz(dim)),newsz])));
    error('Max not implemented yet');
end
% Normalize
mi = min(out_tens(:));
ma = max(out_tens(:));
out_tens = (out_tens-mi)/(ma-mi);

end


function [ networkResp ] = RBF( respList )
%RBF Summary of this function goes here
%   Detailed explanation goes here

rbf_scale = 0.05;

l4out = cellfun(@(x) x.l4Resp, respList, 'UniformOutput', false);

l4out = cellfun(@(x) cellfun(@(y) reshape(y,size(y,1)*size(y,2)*size(y,3),size(y,4)),x,'UniformOutput',false),l4out, 'UniformOutput',false);
vec = cell(size(l4out));
networkResp.resp = cell(size(l4out{1},1),size(l4out{1},2));

for i=1:size(l4out{1},1)
    for j=1:size(l4out{1},2)
        for k=1:size(vec,1)
            vec{k} = l4out{k}{i,j};
        end
        D = cell2mat(vec)' * cell2mat(vec);
        beta = rbf_scale * 1.0 / sqrt(sum(D( : ) / size(D, 1) ^ 2));
        
        %Number of populations will equal the number of patterns
        popnum = numel(vec);
        
        %This function will take a pair of indices as a single argument, and call
        %rbfOfColumns with predefined coefficient beta on two elements of v4resp
        %that have these given indices.
        
        rbfPatternResp = @(x) rbfcolumns(beta, vec{ x(1) }, vec{ x(2) });
        
        fprintf('calculating rbf pattern for block (%d,%d)\n',i,j);
        
        %supply pairs of indices to rbfPatternResp to call it on each pair
        patternList = cellfun(rbfPatternResp, listPairs(1 : popnum), 'UniformOutput', false);
        
        
        networkResp.resp{i,j} = reshape(patternList, [popnum popnum]);
    end
end


end


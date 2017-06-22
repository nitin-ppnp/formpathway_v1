function [ resp ] = classifierOP( dirPath)
%CLASSIFIEROP Summary of this function goes here
%   Detailed explanation goes here


load('model.mat');
load([dirPath,'/','formresp.mat']);

[y,x] = meshgrid((1:length(properties.l3.yct)),(1:length(properties.l3.xct)));
l3xy = [y(:),x(:)];
catsize = size(formresp.v1f,4);

% The lowest response is -0.45 and hence default response should be less
% than that (-1*ones..)
% resp = zeros(catsize,length(properties.l3.yct),length(properties.l3.xct),properties.numShapes,properties.numDirections);
resp = nan(catsize,length(properties.l3.yct),length(properties.l3.xct),properties.numShapes,properties.numDirections);


%  Weight sharing and response calculation for each l3 neuron
for i = 1:size(l3xy,1)
    
    for j=1:catsize
        t = formresp.l4resp{l3xy(i,1),l3xy(i,2)}(:,:,:,j);
        X = t(:)-mean(t(:));
        scores = evaluateRBFN(Centers,betas,Theta,X');
        resp(j,l3xy(i,1),l3xy(i,2),1,1) = scores(1);
        resp(j,l3xy(i,1),l3xy(i,2),2,1:6) = scores(2:7);
        resp(j,l3xy(i,1),l3xy(i,2),3,1:4) = scores(8:11);
    end
    
end
mi = min(resp(:));
ma = max(resp(:));
resp(isnan(resp)) = mi; 
resp = (resp-mi)/(ma-mi);


end


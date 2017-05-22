function [ TrainImageList ] = getTrainingImagePath( properties )
%GETTRAININGIMAGEPATH Summary of this function goes here
%   Detailed explanation goes here

t = dir(properties.TrainingPath);
i = ismember({t.name},{'.','..'});
t(i)=[];
for i=1:length(t)
    TrainImageList{i} = strcat(properties.TrainingPath,t(i).name);
end
end


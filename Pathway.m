videofolder = 'video';
conditionList = storeAVIasPNGset(videofolder);

formrespList = cellfun(@(x) computeFormOutput(x), conditionList, 'UniformOutput', false);
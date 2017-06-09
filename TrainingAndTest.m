
%% Run the properties script to initialize the model parameters
Properties;

%%

% Get the path to training images
[train, test] = getImagePath(properties);
TrainList = {};
TestList = {};
for m=1:length(train)
    for n=1:length(train{m})
        TrainList = [TrainList train{m}{n}];
    end
end
for m=1:length(test)
    for n=1:length(test{m})
        TestList = [TestList test{m}{n}];
    end
end

l3x = properties.l3neuronToTrain(1);
l3y = properties.l3neuronToTrain(2);
numCat = (floor((length(TrainList)-1)/properties.TrainDataPerCat)+1);

%% script block
X=[];
y=[];
data=[];
catsize = zeros(length(TrainList),1);
idxes = [1;catsize];
for m = 1:length(TrainList)
    
    load(strcat(TrainList{m},filesep,'formresp.mat'));
    sz = size(formresp.l4resp{l3x,l3y});
    
    catsize(m) = size(formresp.v1f,4);
    idxes(m+1) = idxes(m)+catsize(m);
    arrresp = zeros(sz(1)*sz(2)*sz(3),sz(4));
    for i=1:catsize(m)
        t = formresp.l4resp{l3x,l3y}(:,:,:,i);
        arrresp(:,i) = t(:)-mean(t(:));
    end
    
    X = [X;arrresp'];
    y = [y;(floor((m-1)/properties.TrainDataPerCat)+1)*ones(catsize(m),1)];
    if(size(X,1)~=size(y,1))
        error('Dimesnion mismatch across data and labels');
    end
end

%%
% ===================================
%     Train RBF Network
% ===================================

disp('Training the RBFN...');

% Train the RBFN using 1 centers per category.
[Centers, betas, Theta] = trainRBFN(X, y, 1, true);

save('model.mat', 'Centers','betas','Theta','TestList','TrainList','properties');

%%
% ========================================
%       Measure Training Accuracy
% ========================================
% Set 'm' to the number of data points.
m = size(X, 1);
TrainScoreMat = zeros(m,numCat);
disp('Measuring training accuracy...');

numRight = 0;

wrong = [];
y_prime = zeros(size(y));

% For each sample...
for i = 1 : m
    % Compute the scores for both categories.
    scores = evaluateRBFN(Centers, betas, Theta, X(i, :));
    TrainScoreMat(i,:) = scores';
    [maxScore, category] = max(scores);
    y_prime(i) = category;
    % Validate the result.
    if (category == y(i))
        numRight = numRight + 1;
    else
        wrong = [wrong; i];
    end
    
end
% Get which class does miscalssified samples belongs to and predicted to
% which class
for i=2:length(idxes)
mask=(idxes(i)-wrong)>0 & (wrong-idxes(i-1))>0;
w(:,i-1) = wrong-idxes(i-1)+1;
w(mask==0,i-1) = 0;
end
w = sum(w,2);
w = [w,y(wrong),y_prime(wrong)];

accuracy = numRight / m * 100;
fprintf('Training accuracy: %d / %d, %.1f%%\n', numRight, m, accuracy);


%%
% ========================================
%       Measure Validation data Accuracy
% ========================================

for m = 1:length(TestList)
    load(strcat(TestList{m},filesep,'formresp.mat'));
    
    
    catsize = size(formresp.v1f,4);
    
    for i=1:catsize
        t = formresp.l4resp{l3x,l3y}(:,:,:,i);
        arrresp(:,i) = t(:)-mean(t(:));
    end
    
    testX = arrresp';
    testy = (floor((m-1)/properties.TestDataPerCat)+1)*ones(catsize,1);
    testdata = [testX,testy];
    
    
    % Set 'm' to the number of data points.
    m = size(testX, 1);
    TestScoreMat = zeros(m,numCat);
    
    
    disp(strcat('Measuring test accuracy for folder',TestList{n},'...'));
    
    testnumRight = 0;
    
    testwrong = [];
    
    % For each sample...
    for i = 1 : m
        % Compute the scores for all categories.
        scores = evaluateRBFN(Centers, betas, Theta, testX(i, :));
        
        [maxScore, category] = max(scores);
        TestScoreMat(i,:) = scores';
        % Validate the result.
        if (category == testy(i))
            testnumRight = testnumRight + 1;
        else
            testwrong = [testwrong; i];
        end
        
    end
    
    testaccuracy = testnumRight / m * 100;
    fprintf('Test accuracy: %d / %d, %.1f%%\n', testnumRight, m, testaccuracy);
end

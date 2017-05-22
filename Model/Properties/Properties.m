%% Model Params
properties.isTraining = true;
properties.TrainingPath = 'Training data/Shapes/';


%% Layer 1 Properties
properties.l1.gaborLen = 10;
properties.l1.gaborWidth = properties.l1.gaborLen*0.7;
properties.l1.gaborWaveNum = 2 * pi / properties.l1.gaborLen / 1.8;
properties.l1.threshold = 10;
properties.l1.normFactor = 70;



%% Layer 2 properties

properties.l2.threshold = 0.01;
properties.l2.normFactor = 1;

%% Layer 4 properties

properties.l4.fSize = 3;
properties.l4.fDist = 1;
properties.frame.dim = [500,500];
function  GABA = mkgaba(properties)
%MKGABA   returns a 3D array with 2D Gabor filters with multiple
%         different directions.

%
%                Version 0.0,  9 October 1999 by Martin Giese.
%
%                Tested with MATLAB 5.3 on a Pentium II under W98
%


%         set default parameters

sag = properties.l1.gaborLen;          % length
sbg = properties.l1.gaborWidth;   % width
k0g = properties.l1.gaborWaveNum; % wave number

phgab = 0:7;            % angles
phgab = phgab / length(phgab) * pi;

GABA = mkgabf(phgab, [sag, sbg], k0g);


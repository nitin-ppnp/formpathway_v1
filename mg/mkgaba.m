function  GABA = mkgaba();
%MKGABA   returns a 3D array with 2D Gabor filters with multiple
%         different directions.

%
%                Version 0.0,  9 October 1999 by Martin Giese.
%
%                Tested with MATLAB 5.3 on a Pentium II under W98
%


%         set default parameters

sag = 10 * 1;12;          % length
sbg = sag * 0.7;8 / 15;   % width
k0g = 2 * pi / sag / 1.8; % wave number

phgab = [0:7];            % angles
phgab = phgab / length(phgab) * pi;

GABA = mkgabf(phgab, [sag, sbg], k0g);


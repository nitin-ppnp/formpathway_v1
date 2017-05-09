function  [FV4bar, xcv4, ycv4] = V1mr2V4rb(FV1f, FV1c,  xgct, ygct)
%[FV4bar, xcv4, ycv4] = V1r2V4rb(FV1f, FV1c, xgct, ygct);
%         transforms the responses FV1 of the V1 Gabor filter
%         on fine and coarsae scale of resolution (FV1f and FV1c)
%         into the responses of an array of spatially 
%         invariant V4 detectors. The additional input argument
%         vectors specify the center of the Gabor functions.
%         The additional output vectors specify the centers
%         of the bar detectors.
%        
 
%
%                Version 0.0,  9 October 1999 by Martin Giese.
%
%                Tested with MATLAB 5.3 on a Pentium II under W98
%

szFV1 = size(FV1f);

%         set parameters
%nrfV4 =  [3, 6];       %  spatial sampling of RF 
%nrfV4 =  [6, 6];
%ngb = [-1 : 1];        %  neigborhood vector
%ngb = [-2 : 2];        %  neigborhood vector
ngb = (-3 : 3);        %  neigborhood vector
nrfV4 =  [20, 20];

%phbd = [0:szFV1(3)-1];
%barlg = 3; 0.1;            %  length of the bars

%phbd = pi * phbd / length(phbd);
%phgab = phbd;


%         define V4 RF centers equally spaced between 
%         the Gabor filters
dctx = (max(xgct) - min(xgct)) / nrfV4(1);
xcv4 = xgct(1) + (-0.5 + 1:nrfV4(1)) * dctx;
dcty = (max(ygct) - min(ygct)) / nrfV4(2);
ycv4 = ygct(1) + (-0.5 + 1:nrfV4(2)) * dcty;



%         create neighborhood vectors
[Xng, Yng] = meshgrid(ngb, ngb);
xnv = Xng(:);
ynv = Yng(:);

%         create matrices with V1 positions
[V1cx, V1cy] = meshgrid(1:length(xgct), 1:length(ygct));
[xgabc, ygabc] = meshgrid(xgct, ygct);



%         calculate the cell response
for l = 1:length(xcv4)  %iterate over all RF centers
   for m = 1:length(ycv4)
      
         %   find closest V1 cell to RF center of the V4 cell
         index = (xgabc - xcv4(l)).^2 +  (ygabc - ycv4(m)).^2;
         index = find(index == min(index(:)));
         indV1x = V1cx(index(1));
         indV1y = V1cy(index(1));


         %   find closest V1 orientation tuning
         %phV1ind = cos(phgab - phbd(n));
         %phV1ind = find(phV1ind == max(phV1ind));
         %phV1ind = phV1ind(1);


         %   get cell indices within the RF
         xv_tmp = xnv + indV1x;
         yv_tmp = ynv + indV1y;
         indval = find(xv_tmp > 0 & xv_tmp <= length(xgct) ...
                       & yv_tmp > 0 & yv_tmp <= length(ygct));
         xv_tmp = xv_tmp(indval);
         yv_tmp = yv_tmp(indval);
        
         %   get maximum acivity over RF for each direction and scale
         for n = 1:szFV1(3)   % iterate over the directions
                 max_f = max(diag(FV1f(yv_tmp, xv_tmp, n)));
                 max_c = max(diag(FV1c(yv_tmp, xv_tmp, n)));
                 FV4bar(m, l, n) = max(max_f, max_c);
         end
   end
end

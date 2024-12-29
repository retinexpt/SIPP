function W = weights_nonlocal(f,ws,ps,ms,binary,sigma,h,weight_thres)
% Helper function to construct non-local weight matrix between image pixels
% as introduced by Buades, Coll and Morel.
%
%      W(x,y) := exp(-d^2(patch(x),patch(y))/h^2),
% where
%  d^2(patch(x),patch(y)) = sum(in terms of t){G_sigma(t)*(f(x+t)-f(y+t))^2}
% and point y is within a window of size (2*ws+1)x(2*ws+1), centered at x.
% and G is the Gaussian kernel.
% Note: For each point x, only keep a few, large W(x,:) and discard the rest.
%
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% W = weights_nonlocal(f,ws,ps,ms,binary,sigma,h,weight_thres)
%
% Input:
% ------
% f         - input image (nxm), N = nxm
% ws        - half of search window size
% ps        - half of patch size
% ms        - number of neighbors (node degree, coefficients to be kept)
% binary    - binarize the weight matrix?
%             false: Take the non-zero values as they are
%             true: set the non-zero values to be 1.
% sigma     - scale factor for patch-window Gaussian kernel
% h         - scale factor in W (e.g. 1)
% weight_thres  - W(x,y)<weight_thres: W(x,y) = weigth_thres (e.g. 10e^-5)
%
%    Note: If there is only one input, the default values are:
%                       ws = 10, ps = 5, ms = 8, binary = true, sigma = 3.0
%
% Output:
% -------
% W         - weight matrix (NxN)
%
%
% When using this code, please do cite our papers:
%
% D. Zosso, G. Tran, S. Osher, "A unifying retinex model based on non-local
% differential operators," IS&T / SPIE Electronic Imaging: Computational
% Imaging XI, San Francisco, USA, 2013.
% DOI: http://dx.doi.org/10.1117/12.2008839
% Preprint: ftp://ftp.math.ucla.edu/pub/camreport/cam13-03.pdf
%
% D. Zosso, G. Tran, S. Osher, "Non-local Retinex - A Unifying Framework
% and Beyond," SIAM Journal on Imaging Science (submitted).
% Preprint: ftp://ftp.math.ucla.edu/pub/camreport/cam14-49.pdf
%

if (nargin==1)
    binary = true;
    sigma = 3.0;
    ws = 10;
    ps = 5;
    ms = 8;
end

[m, n] = size(f);
r = m*n;
G = fspecial('gaussian', [40, 40], sigma);

% Computing distance
dist = zeros((2*ws+1)*(2*ws+1), r);

padu = padarray(f,[ws ws],'symmetric','both');

for i = -ws:ws
    for j = -ws:ws
        shiftpadu = padarray(f,[ws-i ws-j],'symmetric','pre');
        shiftpadu = padarray(shiftpadu,[ws+i ws+j],'symmetric','post');
        
        tempu = (padu-shiftpadu);
        tempu = tempu(1+ws:m+ws, 1+ws:n+ws);% tempu(r,c) = f(r,c) - f(r+i,c+j);
        
        padtempu = padarray(tempu,[ps,ps],'symmetric','both');
        
        uu = conv2(padtempu.^2, G, 'same');
        uu = uu(1+ps:m+ps, 1+ps:n+ps);
        
        k=(j+ws)*(2*ws+1)+i+ws+1;
        dist(k, :) = reshape(uu, 1, []);
    end
end
% Computing the weight
W = sparse(r,r);

idx = (0:r-1)';
idx = idx*(2*ws+1)^2;

dist(dist==0) = 1e+5; % Assign a large value -> don't count that pixel itself
for i = 1 : ms
    [y, minindex] = min(dist);% choose the ms smallest distance
    
    % position in the vector image f
    ind1 = [1:r]';
    minindex = minindex';
    ind2 = floor((minindex-1)/(2*ws+1))*(m-2*ws-1) + minindex +ind1 -ws-1-ws*m;
    
    tmpindex = find(ind2>0 &ind2<=r);
    
    if (binary)
        W = W + sparse(ind1(tmpindex), ind2(tmpindex), 1, r, r);
    else
        values = max(exp(-y(tmpindex)/h^2),weight_thres);
        W = W + sparse(ind1(tmpindex),ind2(tmpindex),values,r,r);
    end
    idx2 = idx + minindex; % position in the matrix dist
    dist(idx2) = inf; % assign inf so that we can come to the next smallest distance
end

% L0 Retinex test for shadow removal
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
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

%% prologue

clear all;
close all;
clc;

% image setup
filename = 'adelson2.jpg'; % test Image is from IPOL
scale = 'log'; % linear or log image prescaling (gamma correction)
dwnsample = 1; % downsampling factor for speed

% Model parameters
p = 0; % L1-based retinex
lambda = 0.15; % pick a filter parameter / threshold
alpha = 0.01; % weight of additional term L2(r)
beta = 0; % weight of additional term L2(r-i)
rho = 0.10; % penalty weight for ADMM
inner = 150; % maximum number of inner ADMM iterations
relTol = 1e-4; % relative tolerance for L0/L1 optimization
pcgTol = 1e-6; % PCG-tolerance for L0/L1 optimization
filter = 'hard'; % Morel-like hard thresholding



%% preprocessing


% image loading
I = double(imread(filename));
I = mean(I,3);

% downsample, normalize and log-convert 
I = downsample(I', dwnsample);
I = downsample(I', dwnsample);

I = I/max(I(:));

im = I;

switch scale
    case 'log'
        I = log(0.1+255*I);
    case 'linear'
        I = I*5.5;
end


% weight 1 -- sparsity of gradients within same color
w1 = weights_local(I);

% weight 2 -- fidelity with semi-local Gaussian weights
w2 = w1;

% w = max(w2,w1)
W = max(w1,w2);

% selecting and preparing the gradient filter function / adaptive threshold
[f,tau] = gradient_filter(filter,w1,w2,lambda);



%% main computation

% Gradient Fitting
switch p
    case 0
        r = L0_retinex_solver( W, alpha, beta, f, tau, I(:), rho, inner, relTol, pcgTol );
    case 1
        r = L1_retinex_solver( W, alpha, beta, f, tau, I(:), rho, inner, relTol, pcgTol );
    case 2
        r = L2_retinex_solver( W, alpha, beta, f, tau, I(:) );
end

% reshape
r = reshape(r,size(I));




%% postprocessing

% compute difference before/after retinex
s = (I - r);
s = exp(s);
s = ((s-min(s(:)))/(max((s(:)))-min(s(:))));


% recovered reflectance clip outliers
r = exp(r);
o = ((r-min(r(:)))/(max((r(:)))-min(r(:))));


%% Visualization
figure();

% input image
subplot(131);
imshow(im/max(im(:))); title('Input');

% Shading
subplot(132);
imshow(imadjust(s)); title('Shading');

% Output
subplot(133);
imshow(imadjust(o)); title('Retinex');
function varargout = ContrastEnhancement(imgName)

% L1/HSV Retinex test for contrast enhancement
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

% clear all;
% close all;
% clc;

% image setup
% filename = 'Flores_Original.jpg'; % test Image is from IPOL
filename = imgName;
scale = 'log'; % linear or log image prescaling (gamma correction)
dwnsample = 1; % downsampling factor for speed

% Model parameters
p = 1; % L1-based retinex
lambda = 0.015; % pick a filter parameter / threshold
alpha = 0.50; % weight of additional term L2(r)
beta = 0.5; % weight of additional term L2(r-i)
rho = 0.10; % penalty weight for ADMM 
inner = 150; % maximum number of inner ADMM iterations
relTol = 5e-5; % relative tolerance for L0/L1 optimization
pcgTol = 1e-6; % PCG-tolerance for L0/L1 optimization
filter = 'hard'; % Morel-like hard thresholding



%% preprocessing


% image loading 
im = double(imread(filename));

% normalize and log-convert each color channel

for ch = 1:size(im,3)
    I = im(:,:,ch);
    
%     I = downsample(I', dwnsample);
%     I = downsample(I', dwnsample);
    
    I = I/max(I(:));
    
    switch scale
        case 'log'
            I = log(1+255*I);
        case 'linear'
            I = I*5.5;
    end
    Ilog(:,:,ch) = I; %#ok<SAGROW>
end

% perform retinex on lightness channel in HSV-space
Itmp = rgb2hsv(Ilog);
I = Itmp(:,:,3); % V channel

% weight 1 -- sparsity of gradients within same color
w1 = weights_color(Ilog);

% weight 2 -- fidelity with semi-local Gaussian weights
w2 = weights_Gaussian(I);
     
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
shading = exp(I - r);
shading = imadjust(shading/max(shading(:)));

% write recovered reflectance as V-channel; re-exponentiate and clip outliers 
Itmp(:,:,3) = imadjust(exp(r)/max(exp(r(:))));
expRetinex = hsv2rgb(Itmp);


%% Visualization 
%  figure(); 

% input image
% subplot(131);
% imshow(im/max(im(:))); title('Input');

% Shading
% subplot(132);
% imshow(shading); title('Shading')

% Output
% subplot(133);
%  imshow(expRetinex); 
% title('Retinex');

varargout{1} = expRetinex;

% elap_time = toc;
% title = sprintf('%s - %f s','NL-Retinex result',elap_time);
% varargout{2} = title;

end
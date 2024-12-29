function [h,mu,sigma] = histogramGauss(l,r,varargin)
%histogramGauss compute Gaussian histogram
% Compute Gaussian histogram with parameters l and r
%
% INPUT:
%  l                (double) value at zero
%  r		        (double) value at L-1
%  L                (int) number of gray values (optional, default: 256)
%
% OUTPUT:
%  h                (vector) histogram
%
%--------------------------------------------------------------------------
% Mila Nikolova ~ RGB_HP_ENHANCE ~ 2014-11-14 ~ last edited: 2014-11-14 (Sören Häuser)

    %% parse input
    p = inputParser;
    p.CaseSensitive = true;
	
	addRequired(p,'l',@(x) (x>=0) && (x<=1));
    addRequired(p,'r',@(x) (x>=0) && (x<=1));
    addOptional(p,'L',256,@isnumeric);

    parse(p,l,r,varargin{:});
    pp = p.Results;
    
    L = pp.L;

    %% set l and r to eps if equal to 0
    if l==0
        l = eps;
    end
    if r==0
        r = eps;
    end

    %% compute histogram
    x = 0:L-1;
    
    if l==1 && r==1
        %do histogram equalization
        h = ones(size(x));
    else
        if l == r
            mu = (L-1)/2;
            sigma = 1/sqrt(2) * mu/sqrt(-log(l));
        else
            log_l = log(l);
            log_r = log(r);

            mu = -(L-1) * (log_l + sqrt(log_l*log_r)) / (log_r-log_l);
            sigma = 1/sqrt(2) * (L-1) * (sqrt(-log_l) - sqrt(-log_r)) / (log_r - log_l);
        end
        h = exp(-.5*((x-mu)/sigma).^2);
    end
   
    %return column vector
    h=h(:);
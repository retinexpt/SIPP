function [f, tau] = gradient_filter( filter_option, w1, w2, lambda )
% Helper function that selects a filter function handle for gradient
% filtering
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% f = gradient_filter( filter_option )
% 
% Input:
% ------
% filter_option - filter name: 'hard', 'soft', 'scale', 'unshrink', 'none'
% w1            - weight matrices for gradient sparsity
% w2            - weight matrices for gradient fidelity
% lambda        - gradient fidelity/sparsity balancing weight
%
% Output:
% -------
% f             - handle to selected filter function
% tau           - sparse adaptive threshold matrix (NxN)
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

switch filter_option
    case 'hard'
        f = @(z,tau) z.*(abs(z)>tau); % hard threshold (Morel, Ma2011)
        sw1 = sqrt(w1);
        sw2 = sqrt(w2);
    case 'soft'
        f = @(z,tau) (z-sign(z)*tau).*(abs(z)>tau); % soft threshold (Ma2010, Ng&Wang)
        sw1 = sqrt(w1);
        sw2 = (w2);
    case 'scale'
        f = @(z,tau) z/(1+tau); % uniform scaling (Kimmel)
        sw1 = (w1);
        sw2 = (w2);
    case 'unshrink'
        f = @(z,tau) z + sign(z)*tau; % unshrinking (Bertalmio&PalmaAmestoy)
        sw1 = sqrt(w1);
        sw2 = (w2);
    case 'none'
        f = @(z,tau) z; % identity (= no filtering)
        sw1 = (w1);
        sw2 = (w2);
end

N = size(sw1,1);

[row,col,v] = find(sw1);
v = v./sw2(find(sw1));

tau = lambda*sparse(row,col,v,N,N);
tau(isinf(tau)) = 1e+5;
end


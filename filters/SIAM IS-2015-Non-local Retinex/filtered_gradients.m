function grad = filtered_gradients(I,w3,f,tau)
% Helper function that filters gradients of image I and weights w3, using
% filter function f and threshold parameter tau.
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% grad = filtered_gradients( I, w3, f, tau )
%
% Input:
% ------
% I         - Image defined on nodes V (Nx1)
% w3        - non-negative weight matrix on edges E (NxN)
% f         - gradient filter function (see gradient_filter.m)
% tau       - thresholding parameter to f
%
% Output:
% -------
% grad      - filtered gradient on edges E (NxN)
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

N = length(I(:));
[row,col,~] = find(w3);
z = sparse(row,col, I(col)-I(row),N,N);
fgrad = f(z,tau);
grad = fgrad.*sqrt(w3);
end
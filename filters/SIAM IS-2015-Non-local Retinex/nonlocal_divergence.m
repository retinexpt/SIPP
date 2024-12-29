function div = nonlocal_divergence( W, v )
% Helper function that computes the non-local divergence of vector v on
% graph weights W.
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% div = nonlocal_divergence( W, v )
% 
% Input:
% ------
% W         - Weight matrix (NxN)
% v         - vector field (NxN)
%
% Output:
% -------
% div       - divergence of vector field (Nx1)
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
N = size( W, 1 );

in = sqrt(W).*v;
in = in - in';

div = in*ones(N,1);
return

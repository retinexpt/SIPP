function r = L2_retinex_solver( W, alpha, beta, f, tau, I )
% Core function for the p=2 (quadratic fidelity, Poisson) retinex
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% r = L2_retinex_solver( W, alpha, beta, f, tau, I )
%
% Input:
% ------
% W         - weight matrix of size NxN
% alpha     - contrast compression, weight of L2(r)^2 term
% beta      - fidelity, weight of the term L2(r-i)^2
% f         - the gradient filter function
% tau       - threshold NxN
% I         - original image written as a column vector Nx1
%
% Output:
% -------
% r         - estimated reflectance (Nx1)
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
L = make_Laplacian( W );
b = filtered_Laplacian( I, L, f, tau );

[Ny, Nx] = size( I );

% use \ to let Matlab determine appropriate solver
r = ( (alpha+beta)*speye(Nx*Ny) - L ) \ ( beta*I(:) - b );

%r = reshape(r, Ny, Nx);

end


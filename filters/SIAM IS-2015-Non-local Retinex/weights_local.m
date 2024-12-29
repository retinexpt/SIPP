function W = weights_local(I)
% Helper function to construct local weight matrix between image pixels
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% W = weights_local(I)
%
% Input:
% ------
% I         - input image (nxm), N = nxm
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
[Ny, Nx] = size(I);
N = Nx * Ny;

[yi, xi] = ind2sub( [Ny,Nx], 1:N );

xip = xi+1;
yip = yi+1;

ix = find( xip <= Nx );
jx = sub2ind( [Ny,Nx], yi(ix), xip(ix) );

iy = find( yip <= Ny );
jy = sub2ind( [Ny,Nx], yip(iy), xi(iy) );

W = sparse( [ix, iy], [jx, jy], 1, N, N );
end


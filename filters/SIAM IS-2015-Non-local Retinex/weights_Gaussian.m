function W = weights_Gaussian( I, d, sigma )
% Helper function to compute "semi-local" distance-based Gaussian weights
% W(point1,point2) =
%     {1/(2*pi*sigma^2)}*exp{-dist^2(point1,point2)/(2sigma^2)}
%
% where point1 and point2 are two points in I, 
% and point2 is in a square of size (2*d+1)x(2*d+1), centered at point1.
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% Input:
% ------
% I         - Input image (nxm), N = nxm
% d         - radius of Gaussian kernel support
% sigma     - standard deviation of Gaussian kernel
%
% Output:
% -------
% W         - sparse weight matrix (NxN)
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
    d=3;
    sigma = 3;
end

[Ny, Nx] = size(I);
N = Nx * Ny;
[yi, xi] = ind2sub( [Ny,Nx], 1:N );

% Gaussian kernel
kernel = fspecial( 'Gaussian', 2*d+1, sigma ); 
% kernel at the center = 0
kernel( size(kernel,1)/2+0.5, size(kernel,2)/2+0.5 ) = 0;
% Normalized kernel
kernel = kernel / sum(kernel(:));
%--> kernel can be used as a LUT, now

W = sparse(N,N);

for dx = -d:d
    for dy = -d:d
        xip = xi+dx;
        yip = yi+dy;
        % Check two points are within a square of size 2d+1 and within the image size range
        i = find( (xip <= Nx) & (xip > 0) & (yip <= Ny) & (yip > 0) );    
        
        j = sub2ind( [Ny,Nx], yip(i), xip(i) );
        W = W + sparse( i, j, kernel(dy+d+1,dx+d+1), N, N );
    end
end

end
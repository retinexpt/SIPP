function r = L1_retinex_solver( W, alpha, beta, f, tau, I, rho, inner, relTol, pcgTol )
% Core retinex solver for the L1 (p=1) gradient fidelity case.
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% r = L1_retinex_solver( W, alpha, beta, f, tau, I, rho, inner, relTol, pcgTol )
%
% Input:
% ------
% W         - weight matrix of size NxN
% alpha     - contrast compression, weight of L2(r)^2 term
% beta      - fidelity, weight of the term L2(r-i)^2
% f         - the gradient filter function
% tau       - threshold NxN
% I         - original image written as a column vector Nx1
% rho       - penalty weight for the ADMM quadratic constraint penalty
% inner     - max number of ADMM iterations (typical 150)
% reltol    - tolerance to stop the ADMM iterations (relTol = 5e-5)
% pcgTol    - tolerance to stop the pcg in solving Ax=b (pcgTol = 1e-6)
%
% Output:
% -------
% r         - reflectance of size Nx1
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

% PreCompute
N = length(I(:));
L = make_Laplacian(W);

% initialization
nabla_i = filtered_gradients( I, W, f, tau );
d = sparse( N, N );
mu = sparse( N, N );
r = I;

A = (alpha/rho + beta/rho)*speye(N) - L;

err = 1;
tol = relTol*norm(I,2);
k = 0;

[rows,cols,values] = find(W);
svalues = sqrt(values);

while ((err>tol) && (k<inner))
    k = k+1;
    
    % r-step
    rp = r;
    div_d_mu = nonlocal_divergence( W, d - mu/rho );
    b = beta/rho*I - div_d_mu;
    [r,~] = pcg(A,b,pcgTol,100);
    
    % d-step
    nabla_r = sparse(rows, cols, (r(cols)-r(rows)).*svalues, N, N );
    
    dtmp = nabla_r - nabla_i + mu/rho;
    d = (dtmp-sign(dtmp)*0.5/rho).*(abs(dtmp) >(0.5/rho)) + nabla_i;
    
    % mu-step
    mu = mu + rho*( nabla_r - d );
    
    % error
    err=sum(sum((rp-r).^2));
end

end

function W = weights_color(I,ws,thres)
% Helper function to compute color-based weights
% Compute the color weight (measure the similarity in color) given by the 
% following formula:
%      W(x,y) = 1 if  cos((rx gx bx), (ry gy by))>=thres, 
%             = 0, otherwise
% for all y in the window search of size (2*ws+1)x(2*ws+1), centered at x
%      
%
% Authors: Dominique Zosso & Giang Tran
% UCLA, Department of Mathematics
%
% zosso@math.ucla.edu --- http://www.math.ucla.edu/~zosso
% Initial release 2014-08-11 (c) 2014
%
% W = weights_color(I,ws,thres)
%
% Input:
% ------
% I         - input color image (nxm), N = nxm
% ws        - half of the window size. ws default is 2
% thres     - color threshold. thres default is cos(5.0*pi/180.0)
%
% Output:
% -------
% W         - the color-distance based binary weights (NxN)
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

if (nargin == 1)
    ws = 2;
    thres = cos(5.0*pi/180.0);
end

[rows,cols,h] = size(I);
% patch window vector at every pixel Ipatch(1:h,i) = (ri,gi,bi) 
Ipatch = zeros(h,rows*cols);
for i=1:h
    tmp = I(:,:,i);
    Ipatch(i,:) = tmp(:);
end
% Normalize 
SSI = sqrt(sum(Ipatch.^2));% norm of each column of Ipatch
Ipatch = Ipatch./repmat(SSI,h,1);

% dist(:,i) = cos(I_i(t)*I_j(t)) where -ws <= t1,t2 <= ws for all j in the search window centered at i
pixels = rows*cols;
dist = zeros((2*ws+1)^2,pixels);
[r,c] = ind2sub([rows,cols],1:pixels);
for wc = 0:ws
    for wr = -ws:ws
        idx =1:pixels;
        
        im_index = wr+wc*rows +idx;% position in the image
        
        idx_keep = find(wr+r > 0 & wr+r <= rows & wc+c<=cols);
       
        k=(wc+ws)*(2*ws+1)+wr+ws+1;% position in the search window
        dist(k,idx_keep) = sum(Ipatch(:,im_index(idx_keep)).*Ipatch(:,idx_keep));% cosine distance
        dist((2*ws+1)^2+1-k,im_index(idx_keep)) = dist(k,idx_keep);% reflect through the vertical axis passing origin
   end
end
% Computing the weight by define dist(dist<thres)=0;

dist(dist==1.0) = 0.0;
dist(dist<thres) = 0.0;% disregard unsimilarity pixels
[trows,tcols,~] = find(dist); % trows in 1:(2*ws+1)^2; tcols in 1:pixels

% position in the vector image I
ind1 = tcols; 
ind2 = ind1 + trows + floor((trows-1)/(2*ws+1))*(rows-2*ws-1)-ws-1-ws*rows;
%W = sparse(ind1,ind2,tvalues,pixels,pixels);
W = sparse(ind1,ind2,1,pixels,pixels);






 
    

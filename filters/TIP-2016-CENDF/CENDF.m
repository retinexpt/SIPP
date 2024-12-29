function varargout=CENDF(I,c,alpha)

% This is an implementation of the following paper
% @article{yu2019low,
%   title={Low-illumination image enhancement algorithm based on a physical lighting model},
%   author={Yu, Shun-Yuan and Zhu, Hong},
%   journal={IEEE Transactions on Circuits and Systems for Video Technology},
%   volume={29},
%   number={1},
%   pages={28--37},
%   year={2019},
%   publisher={IEEE}
% }
% This code was written by Chongyu Wang and Tian Pu. The implementation differs from the orginal
% paper in the illumination adjustment function. The authors used a logarithmic function,
% whereas we use the gamma law. Our experiments show that gamma law performs better.



[m,n,channel]=size(I);

tic;
I=rgb2hsv(I);
V=I(:,:,3);

sigma= sqrt(m*n)*c;

window=floor(sigma*6+1);

Ker1=fspecial('gaussian',window,sigma);
Ker2=fspecial('gaussian',window,4*sigma);
DoG=Ker2-Ker1;
w=Hfunction(DoG)/sum(sum(Hfunction(DoG)));


[fv,fh]=ForwardD(V);
grad=sqrt(fv.^2+fh.^2);


t=xfilter2(w,grad);

wt=t/max(max(t));
B=Hfunction(grad-alpha*t);
g=gfunction(B);


tau=15;
L=V;

err=1;

i=1;
while(err>7*10e-4&&i<50)
    
    [fv,fh]=ForwardD(L);
    
    grad=sqrt(fv.^2+fh.^2);
    
    t=xfilter2(w,grad);
    B=Hfunction(grad-alpha*t);
    g=gfunction(B);
    L1=aosiso(L,g,15);
    L1=max(L1,V);
    
    
    norm_m = sqrt(sum(sum((wt.*(L1-L)).*(wt.*(L1-L)))));
    norm_n = sqrt(sum(sum((wt.*L).*(wt.*L))));
    err = norm_m/norm_n;
    
    L=L1;
    i=i+1;
    
end

R=V./(L+eps);
% La=log2(1+L); % author recommended
% La=log2(255*(1+L)./(255+L));
% La=log(1+L); % author recommended
La=L.^(1/2.2);  % original 1/2.2

I(:,:,3)=La.*R;
Enhanced=hsv2rgb(I);
varargout{1} = uint8(Enhanced*255);
elap_time = toc;
title = sprintf('%s - %f s', 'CENDF',elap_time);
varargout{2} = title;

end

function [Duv,Duh] = ForwardD(U)

Duv = [diff(U,1,2), U(:,1) - U(:,end)];
Duh = [diff(U,1,1); U(1,:) - U(end,:)];
end


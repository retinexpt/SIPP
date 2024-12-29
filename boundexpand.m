function ImageEx=boundexpand(KerS,ImageIn)
%expand the image border to make them continuous

[m,n]=size(ImageIn);
[mm,nn]=size(KerS);
ImageEx=zeros(m+mm-1,n+nn-1);

mm = floor(mm/2);
nn = floor(nn/2);

ImageEx(1+mm:m+mm,1+nn:n+nn)=ImageIn;%center

ImageEx(1:mm,1:nn)=ImageIn(1,1);%upleft corner
ImageEx(1:mm,n+nn+1:n+nn+nn)=ImageIn(1,n);%upright corner
ImageEx(m+mm+1:m+mm+mm,1:nn)=ImageIn(m,1);%bottomleft corner
ImageEx(m+mm+1:m+mm+mm,n+nn+1:n+nn+nn)=ImageIn(m,n);%bottomright corner

for k=mm+1:m+mm
	ImageEx(k,1:nn)=ImageIn(k-mm,1);
	ImageEx(k,n+nn+1:n+nn+nn)=ImageIn(k-mm,n);
end

for k=nn+1:n+nn
	ImageEx(1:mm,k)=ImageIn(1,k-nn);
	ImageEx(m+mm+1:m+mm+mm,k)=ImageIn(m,k-nn);
end
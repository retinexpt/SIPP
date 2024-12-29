function ImageOut=xfilter2(Ker,ImageIn)
% filter the image with a kernel by Fast Fourier Transform

[nn,mm]=size(ImageIn);

imgEx=boundexpand(Ker,ImageIn);

[n,m] = size(imgEx);
[n1,m1] = size(Ker);

FimgEx = fft2(imgEx);  
FKer = fft2(Ker,n,m);

FimgEx = FimgEx.*FKer;
YT = real(ifft2(FimgEx));

nl = floor(n1/2);
ml = floor(m1/2);

ImageOut = YT(1+nl+nl:nn+nl+nl,1+ml+ml:mm+ml+ml);


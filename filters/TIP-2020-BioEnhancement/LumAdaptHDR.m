function outM= LumAdaptHDR(img)

% clipped pixels
idx1 = floor(0.05*size(img,1)*size(img,2));
idx2 = floor(0.95*size(img,1)*size(img,2));
tcim = sort(img(:));
cimg = tcim(idx1:idx2);

wsd = 5.0;
gm = mean(cimg(:))/(1+wsd*std(cimg(:)));

img0 = imresize(img,size(img)./5,'bilinear');
cst0 = LocalStd(img0,[21,21]); 
cst = imresize(cst0,size(img),'bilinear');

lm = gm.*img./(1+wsd*cst);

c =exp(gm);

wg = img.^0.2;
wl = 1-wg;

outM = img.^c./(img.^c+ (wl.*lm).^c+ (wg.*gm).^c+eps);  

ww = 0.5;
Hs = fspecial('gaussian',[100 100],51);   
outM = (1+ww)*outM - ww*imfilter(outM,Hs,'same','replicate');

outM = max(outM,0); outM = min(outM,1);
outM = (outM-min(outM(:)))./(max(outM(:))-min(outM(:)));

% post correction for HDR images
gg= median(outM(:))./(mean(outM(:))+eps);
outM = outM.^gg;



function outM = LumAdaptLDR(img)

idx1 = floor(0.05*size(img,1)*size(img,2));
idx2 = floor(0.95*size(img,1)*size(img,2));
tcim = sort(img(:));
cimg = tcim(idx1:idx2);

wsd = 5.0;
gm = mean(cimg(:))/(1 + wsd*std(cimg(:)));

cst = LocalStd(img,[21,21]); 
lm = gm.*img./(1+wsd*cst);

c =exp(gm);

wg = img.^0.2;
wl = 1-wg;

outM = img.^c./(img.^c+ (wl.*lm).^c+ (wg.*gm).^c+eps);  

% DOG 
ww = 0.5;
Hs = fspecial('gaussian',[100 100],21);  
outM = (1+ww)*outM - ww*imfilter(outM,Hs,'same','replicate');

outM = max(outM,0);  outM = min(outM,1);
outM = (outM-min(outM(:)))./(max(outM(:))-min(outM(:)));


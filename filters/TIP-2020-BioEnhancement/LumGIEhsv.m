function Clum = LumGIEhsv(img)

for i=1:3
    Ilum = img(:,:,i);
    [hh,ww] = size(Ilum);
    
    % noise-level estimate
    NN = [1 -2 1;-2 4 -2;1 -2 1];
    SN = imfilter(Ilum,NN,'conv','replicate');
    delt = sqrt(pi/2)*sum(abs(SN(:)))/(6*(ww-2)*(hh-2));
    nlevel = 2*delt;   
    [Idetail(:,:,i),Ibase(:,:,i)]= TV_L2_Decomp(Ilum, nlevel);
    
    Hgaus = fspecial('gaussian',[100 100],21);
    ww = imfilter(abs(Idetail(:,:,i)),Hgaus,'conv','replicate');
    wws(:,:,i) = ww./max(ww(:));
    conM(:,:,i) = Idetail(:,:,i);
end

% HSV
hsvmap = rgb2hsv(Ibase);
picL = hsvmap(:,:,3);
tlumM = LumAdaptLDR(picL);

R = Ibase(:,:,1); G = Ibase(:,:,2); B = Ibase(:,:,3);
s=0.6;  
lumM(:,:,1) = tlumM.*(R./(picL+eps)).^s;
lumM(:,:,2) = tlumM.*(G./(picL+eps)).^s;
lumM(:,:,3) = tlumM.*(B./(picL+eps)).^s;


kks = 5.0;  
Clum = lumM + kks.*wws.*conM;
Clum = max(Clum,0);
Clum = min(Clum,1);
Clum = (Clum-min(Clum(:)))./(max(Clum(:))-min(Clum(:)));



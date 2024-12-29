function varargout = neci_processing(pic,varargin)

tic;
[m,n,k]=size(pic);
global tpic
tpic=double(pic);%change to double

picLCH=colorspace('rgb->Lch',pic);
picL=log(picLCH(:,:,1)+1);
key=exp(mean(picL(:)))-1;
picL=picLCH(:,:,1);

Iorig=picL/max(picL(:));
if key<=50
    r=3*log(key/10);
    r=max(min(r,1.4),1);
    x0=r;
    y0=0;
    Igm=y0+sqrt(r^2-(Iorig-x0).^2);
elseif key>=60
    r=3*log(10-key/10);
    r=max(min(r,1.4),1);
    x0=0;
    y0=r;
    Igm=y0-sqrt(r^2-(Iorig-x0).^2);
else
    Igm=Iorig;
end

%         if key<=50
%             y1=0.15;
%             x1=x0-sqrt(r^2-(y1-y0)^2);
%             gama=log(y1)/log(x1);
%             Igm(Iorig>y1)=Iorig(Iorig>y1).^gama;
%         end


k=floor(max(m,n)/8);

Imask=mask(Igm,k);

Ienh=Igm./(log10(Imask*100+1)+1);
Ienh=Ienh/max(Ienh(:));
Mref=Ienh./(picL/(max(picL(:)))+0.01);


picLCH(:,:,1)=CutWhitePoint(Ienh,0.01);
picLCH(:,:,2)=picLCH(:,:,2).*Mref;
varargout{1} = colorspace('Lch->rgb',picLCH);

elap_time = toc;
title = sprintf('%s - %f s', 'NECI result',elap_time);
varargout{2} = title;
% figure,imshow(tpic);
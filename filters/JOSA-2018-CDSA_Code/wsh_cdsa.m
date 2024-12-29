function varargout = wsh_cdsa(pic,varargin)

tic;


global tpic
tpic=ColorCorrect(pic);
tpic=double(tpic);%change to double

% tpic=double(pic);

maxpic=round((tpic(:,:,1)+tpic(:,:,2)+tpic(:,:,3))/3);
pichsv=rgb2hsi(uint8(tpic));
%         blkwin=48;
blkwin=30;
%         ehcpic=CLHE(tpic,blkwin);
ehcpic=CLHE_new(tpic,blkwin);
ehcmax=round((ehcpic(:,:,1)+ehcpic(:,:,2)+ehcpic(:,:,3))/3);
% figure,imshow(uint8(ehcmax));

win=5;
max1=getlocalmax(maxpic,win);
min1=getlocalmin(maxpic,win);
max2=getlocalmax(ehcmax,win);
min2=getlocalmin(ehcmax,win);
delta1=(max1-min1)./(max1+~max1);
delta2=(max2-min2)./(max2+~max2);
climit=0.2; %contrast limit---不能太小也不能太大
tag=delta1<climit;
ratio=(delta2+(climit-delta1).*tag)./(delta1.*(~tag)+climit.*tag);
blkwin=30;%消去artifacts
ratio=getspecialmean(ratio,tpic,blkwin);    %reshape ratio

pichsv(:,:,3)=ehcmax/255;
pichsv(:,:,2)=pichsv(:,:,2).*ratio;
tpic=hsi2rgb(pichsv);

varargout{1} = tpic;


elap_time = toc;
title = sprintf('%s - %f s', 'wsh_cdsa result',elap_time);
varargout{2} = title;
% Demo 
clc;  clear; %close all;

[filename, user_canceled] = imgetfile;
if user_canceled
    map = [];
    filename = [];
    return;
end


% img = im2double(hdrread(filename));   % read HDR original image
img = im2double(imread(filename));
[ww,hh,~] = size(img);
figure;imshow(img,[]);
R = img(:,:,1);
G = img(:,:,2); 
B = img(:,:,3);

tic
% HSV
hsvmap = rgb2hsv(img);
tpicL = hsvmap(:,:,3);
maxa = max(tpicL(:));
a = maxa;
picL = log(tpicL+1)./log(a+1); 
% figure;imshow(picL,[]);
tlumM = LumAdaptHDR(picL);


hsvmap(:,:,3) = tlumM;
Cimg = hsv2rgb(hsvmap);

s = 0.6;  
Cimg(:,:,1) = tlumM.*(R./(tpicL+eps)).^s;
Cimg(:,:,2) = tlumM.*(G./(tpicL+eps)).^s;
Cimg(:,:,3) = tlumM.*(B./(tpicL+eps)).^s;

toc
figure;imshow(Cimg,[]);


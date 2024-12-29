%This is a demo of SCE, corresponding paper "A Structural Compensation Enhancement Method for Non-uniform Illumination Images"


clc;
clear;
 
Original=imread('8.jpg');  % Load a image

in=rgb2hsv(Original);      % RGB to HSV color space
win=11; sigm=1.5;          % Default parameters of local ambient light estimation 
out=SCE(in,win,sigm);      % SCE processing
enhanced=(hsv2rgb(out));   % HSV to RGB color space
% showing and saving processed images 
subplot 121;
imshow(Original);title('Original');
subplot 122;
imshow(enhanced);title('enhanced');
imwrite(enhanced,'Enhanced.bmp')
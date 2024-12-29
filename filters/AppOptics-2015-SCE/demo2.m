%This is a demo of SCE, corresponding paper "A Structural Compensation Enhancement Method for Non-uniform Illumination Images"


clc;
clear;
 
Original=imread('3_1.png');         % Load a gray value image
e=1;                               % Default parameter of LHET in our paper 
win=11; sigm=1.5;                  % Default parameters of local ambient light estimation 
Enhanced1=LHET(Original,e)/255;    % LHET processing
Enhanced2=SCE2(Original,win,sigm); % SCE processing

% showing and saving processed images 
subplot 221;
imshow(Original);title('Original');
subplot 222;
imshow(Enhanced1);title('enhanced LHET');
subplot 224;
imshow(Enhanced2);title('enhanced SCE');
imwrite(Enhanced1,'Enhanced1.bmp');
imwrite(Enhanced2,'Enhanced2.bmp');
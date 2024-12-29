% A variational-based fusion model for nonuniform illumination image enhancement 
% via contrast optimization and color correction
% Qi-Chong Tian and Laurent D.Cohen
% CEREMADE, Universite Paris Dauphine, PSL Research University
% Email: qichong.tian@gmail.com
% 2017-12-15

clc;
clear all
close all

% Input images
img_org = imread('test.png');
% Parameters setting 
alpha = 0.5;  
beta = 0.5;  
gamma = 1; 
tao   = 0.02;   
iterNum = 20;
% Processing with our method
img_out = VFGLE(img_org,alpha,beta,gamma,tao,iterNum);
% Show results
figure;
subplot(1,2,1),subimage(uint8(img_org)),title('original image');
subplot(1,2,2),subimage(uint8(img_out)),title('enhanced image');
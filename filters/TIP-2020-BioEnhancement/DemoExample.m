% Demo 
clc;  clear; %close all;
[filename, user_canceled] = imgetfile;
if user_canceled
    map = [];
    filename = [];
    return;
end

img = imread(filename); % read original image
img = double(img)./double(max(img(:)));
figure;imshow(img,[]);

tClum= LumGIEhsv(img);

figure;imshow(tClum,[]);



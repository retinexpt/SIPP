function varargout = edm_retinex_hsv(imgSrc,varargin)
%------------------------------------------------------------------------- 
% Exploratory data model(EDM) based Retinex
% Author: Tian Pu
% Institute:University of Electronic Science and Technology of China
% ------------------------------------------------------------------------
% EDM based Retinex(EDMR) is a simplified version of CRIE, see Paper 1. 
% EDMR produces results that are nearly same to those of CRIE. Interestingly, 
% it can also be seen as an alternative understanding or implementation of 
% the well-known MSRCR, see Paper 2.
% 
% The major differences between EDMR and MSRCR are as follows:
% 1 EDMR does not need the color restoration function and will not result in
%   the graying effect that MSRCR does.
% 2 Two scales are enough for EDMR to produce visually pleasing results, so EDMR is fast.
% 
% This code is for academic purposes only. If you find it useful, I would
% be grateful if you could cite Paper 1.
% ------------------------------------------------------------------------
% Paper 1
% @article{pu2024non,
% author = {Pu, Tian and Zhu, Qingsong},
% journal= {IEEE Transactions on Consumer Electronics}, 
% title  = {Non-Uniform Illumination Image Enhancement via a Retinal Mechanism Inspired Decomposition}, 
% year   = {2024},
% volume = {70},
% number = {1},
% pages  = {747-756},
% keywords = {Lighting;Mathematical models;Image enhancement;Retina;Histograms;Visualization;
%               Consumer electronics;Image enhancement;vision-based exploratory data model;contrast;residual image},
% doi      = {10.1109/TCE.2024.3377110}
% }
% 
% Paper 2
% @ARTICLE{597272,
%   author  =   {Jobson, D.J. and Rahman, Z. and Woodell, G.A.},
%   journal =   {IEEE Transactions on Image Processing},
%   title   =   {A multiscale retinex for bridging the gap between color images and the human observation of scenes},
%   year    =   {1997},
%   volume  =   {6},
%   number  =   {7},
%   pages   =   {965-976},
%   keywords=   {Color;Layout;Humans;Analog computers;Computer vision;Dynamic range;
%               Image coding;Image restoration;Testing;Visual perception},
%   doi     =   {10.1109/83.597272}
%  }
% ---------------------------------------------------------------------------

[height,width,page]=size(imgSrc);

% we treat grayscale image as a rgb image.
if page == 1
    imgIn(:,:,1) = imgSrc;
    imgIn(:,:,2) = imgSrc;
    imgIn(:,:,3) = imgSrc;
else
    imgIn = imgSrc;
end

Ahsv = rgb2hsv(imgIn)*255;

param_set = varargin{1};

if isempty(param_set)~=1     
    
    sigma = str2num(param_set{1});    
    gamma=str2double(param_set{2});
    idx=find(sigma);
    
%   create the filter kernel
    for i=1:length(idx)
        Ker{idx(i)}=fspecial('gaussian',floor(6*sigma(idx(i))+1),sigma(idx(i)));
    end    
    
%   computing surround images at different scales
    for m=1:numel(idx)
        srdImg{idx(m)}=xfilter2(Ker{idx(m)},Ahsv(:,:,3));
    end
    
%   center-surround retinex
    for m=1:numel(idx)
        imgRx{idx(m)} = log10(Ahsv(:,:,3)+1)-log10(srdImg{idx(m)}+1);
    end 
    
    W=255;    
    img_Enh{1} = Ahsv(:,:,3);    
    for m=1:numel(idx)         
        r_img{m} = (1+imgRx{idx(m)});        
        i_img{m} = max(Ahsv(:,:,3)./r_img{m},0);        
        tm_i_img{m} = W*(i_img{m}./W).^(gamma);       
        img_Enh{m+1}= tm_i_img{m}.*r_img{m};        
    end
    
    sum_all = 0;
        
    for m=2:length(img_Enh)
        sum_all = sum_all + img_Enh{m};
    end
    
    final_enh = 0;
    for m=2:length(img_Enh)
        weight{m} = img_Enh {m}./sum_all;
        final_enh = final_enh + weight{m}.*img_Enh{m};
    end
    
    Ahsv(:,:,3)  = final_enh;    
    Ahsv = Ahsv/255;    
    RGB = hsv2rgb(Ahsv);
    
    varargout{1}=uint8(RGB*255);    
else
    varargout{1} = [];    
end

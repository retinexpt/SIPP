function varargout=MSRCR_process(imgIn,varargin)
%%********************************************
% @ARTICLE{597272,
%   author={Jobson, D.J. and Rahman, Z. and Woodell, G.A.},
%   journal={IEEE Transactions on Image Processing},
%   title={A multiscale retinex for bridging the gap between color images and the human observation of scenes},
%   year={1997},
%   volume={6},
%   number={7},
%   pages={965-976},
%   keywords={Color;Layout;Humans;Analog computers;Computer vision;Dynamic range;Image coding;Image restoration;Testing;Visual perception},
%   doi={10.1109/83.597272}
%  }
% This is an implementation of MSRCR, see the above paper. If it works, it was written by
% Tian Pu, if it doesn't work, I don't know who wrote it.
%
% This implementation differs from the original paper in two aspects:
% 1. Default parameters are provided by my experiments. I changed the gain/offset parameter,
% the three scale parameters.
% 2. I provide a post-correction step to avoid the graying effect. Users
% can disable this step to get the results by the orginal method.
%% *******************************************


dImg=double(imgIn);
[height,width,page]=size(imgIn);

param_set = varargin{1};

if isempty(param_set)~=1
    Gain=str2double(param_set{1});
    offset=str2double(param_set{2});
    Alfa=str2double(param_set{3});
    
    sigma = str2num(param_set{4});
    postcorrect = str2num(param_set{5});
    
    idx=find(sigma);
    
    for i=1:length(idx)
        Ker{idx(i)}=fspecial('gaussian',floor(6*sigma(idx(i))+1),sigma(idx(i)));
    end
    
    if page ==1
        for i=1:length(idx)
            srdImg{idx(i)}=xfilter2(Ker{idx(i)},dImg);
        end
        
        for i=1:length(idx)
            img{idx(i)}=log10(dImg)-log10(srdImg{idx(i)});
        end
        
        imgRe=0;
        for i=1:length(idx)
            imgRe=imgRe+img{idx(i)};
        end
        
        imgRe=imgRe/length(idx);
        varargout{1}=uint8(Gain*log10(Alfa/3)*imgRe+offset);
    else
        % computing surround images at different scales
        for i=1:length(idx)
            srdImgRed{idx(i)}=xfilter2(Ker{idx(i)},dImg(:,:,1));
            srdImgGreen{idx(i)}=xfilter2(Ker{idx(i)},dImg(:,:,2));
            srdImgBlue{idx(i)}=xfilter2(Ker{idx(i)},dImg(:,:,3));
        end
        
        % retinex computation
        for i=1:length(idx)
            imgRed{idx(i)}=log10(dImg(:,:,1)+1)-log10(srdImgRed{idx(i)}+1);
            imgGreen{idx(i)}=log10(dImg(:,:,2)+1)-log10(srdImgGreen{idx(i)}+1);
            imgBlue{idx(i)}=log10(dImg(:,:,3)+1)-log10(srdImgBlue{idx(i)}+1);
        end
        
        imgR=0;
        imgG=0;
        imgB=0;
        for i=1:length(idx)
            imgR=imgR+imgRed{idx(i)};
            imgG=imgG+imgGreen{idx(i)};
            imgB=imgB+imgBlue{idx(i)};
        end
        
        imgR=imgR/length(idx);
        imgG=imgG/length(idx);
        imgB=imgB/length(idx);
        
        %----color restoration ----------
        SumColor=dImg(:,:,1)+dImg(:,:,2)+dImg(:,:,3)+1;
        ClrRed = log10(1+Alfa*dImg(:,:,1)./SumColor);
        ClrGreen = log10(1+Alfa*dImg(:,:,2)./SumColor);
        ClrBlue = log10(1+Alfa*dImg(:,:,3)./SumColor);
        
        out(:,:,1)=uint8(ClrRed.*(Gain*imgR+offset));
        out(:,:,2)=uint8(ClrGreen.*(Gain*imgG+offset));
        out(:,:,3)=uint8(ClrBlue.*(Gain*imgB+offset));
        
        
        %-----------post correction----------------------------------
        if postcorrect == 1
            varargout{1} = post_correction(imgIn, out);
        else
            varargout{1} = out;
        end
        
    end
    
else
    varargout{1} = [];    
end


function varargout = post_correction(imgSrc,imgPost,varargin)

[height, width,page] = size(imgSrc);

if page == 3
    varargout{1}(:,:,1) = max(imgSrc(:,:,1), imgPost(:,:,1));
    varargout{1}(:,:,2) = max(imgSrc(:,:,2), imgPost(:,:,2));
    varargout{1}(:,:,3) = max(imgSrc(:,:,3), imgPost(:,:,3));
else
    varargout{1} = max(imgSrc, imgPost);
end




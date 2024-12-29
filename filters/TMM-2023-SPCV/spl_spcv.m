function varargout = spl_spcv(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% 
% @ARTICLE{10106032,
%   author={Zhou, Mingliang and Wu, Xingtai and Wei, Xuekai and Xiang, Tao and Fang, Bin and Kwong, Sam},
%   journal={IEEE Transactions on Multimedia}, 
%   title={Low-Light Enhancement Method Based on a Retinex Model for Structure Preservation}, 
%   year={2024},
%   volume={26},
%   number={},
%   pages={650-662},
%   keywords={Lighting;Reflectivity;Image enhancement;Dispersion;Standards;Sensitivity;Histograms;Coefficient of variation;retinex model;structure-preserving},
%   doi={10.1109/TMM.2023.3268867}
%   }
  
if strcmpi(option,'ui_name')==1
    varargout{1} = 'Trans Multimedia\2023-SPCV';
    return;
end

if strcmpi(option,'get_parameter')==1
    
    varargout{1} = [];
    
    return;
end

if strcmpi(option,'run')==1
    tic;
    
    im = im2double(imgSrc);
    im = im(:,:,1:3);
    [L, R] = spcv22(im);
    hsv = rgb2hsv(im);
    
    gamma = 2.2;
    I_gamma = L.^(1/gamma);
    S_gamma = R .* I_gamma;
    hsv(:,:,3) = S_gamma;
    eIm = hsv2rgb(hsv);
    imgOut = uint8(eIm*255);
    
    varargout{1} = imgOut;
    elap_time = toc;
    title = sprintf('%s - %f s', '2023-SPCV',elap_time);
    varargout{2} = title;
end


function varargout = spl_star(option, imgSrc, imgName,varargin)
% Interface function
% *************************
% @article{XuSTAR,
%  title={{STAR}: A Structure and Texture Aware Retinex Model},
% author={Xu, Jun and Yu, Mengyang and Liu, Li and Zhu, Fan and Ren, Dongwei and Hou, Yingkun and Wang, Haoqian and Shao, Ling},
% journal={IEEE Transactions on Image Processing},
%   volume={29},  
%   pages={5022-5037},
%  year={2020},
% }

if strcmpi(option,'ui_name')==1
    varargout{1} = 'Trans Image Processing\2020-STAR';
    return;
end

if strcmpi(option,'get_parameter')==1
    param(1).name = 'alpha';
    param(1).value = '0.001';
    
    param(2).name = 'beta';
    param(2).value = '0.0001';
    
    param(3).name = 'pI';
    param(3).value = '1.5';
    
    param(4).name = 'pR';
    param(4).value = '1';
    
    varargout{1} = param;
    
    return;
end

if strcmpi(option,'run')==1
    
    if isempty(varargin) == 1
        inputtitle='Input the cell parameters';
        parameters={'alpha','beta','pI','pR'};
        
        lines=1;
        default={'0.001','0.0001','1.5','1'};
        para_set = inputdlg(parameters,inputtitle,lines,default);
        if isempty(para_set)
			varargout{1} = [];
			varargout{2} = [];
			return;
        end		
    else
        para_set = varargin{1};
    end
    
    alpha = str2double(para_set{1});
    beta = str2double(para_set{2});
    pI = str2double(para_set{3});
    pR = str2double(para_set{4});
    
    tic;
    Im = im2double(imgSrc);
    [L, R] = STAR(imgSrc,alpha, beta, pI, pR);
    hsv = rgb2hsv(Im);
    gamma = 2.2;
    I_gamma = L.^(1/gamma);
    S_gamma = R .* I_gamma;
    hsv(:,:,3) = S_gamma;
    eIm = hsv2rgb(hsv);
    imgOut = uint8(eIm*255);
    
    varargout{1} = imgOut;
    elap_time = toc;
    title = sprintf('%s - %f s', 'STAR',elap_time);
    varargout{2} = title;
end

